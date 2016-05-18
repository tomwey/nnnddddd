class LiveVideo < ActiveRecord::Base
  validates :title, :lived_at, presence: true
  
  mount_uploaders :images, ImagesUploader
  
  scope :fields_for_list, -> { select(:id, :title, :lived_at, :images, :view_count, :channel_id) }
  scope :opened, -> { where(closed: false) }
  scope :recent, -> { order('id desc') }
  
  # 验证直播时间，必须是在将来的某个时间
  validate :check_lived_at
  def check_lived_at
    if self.lived_at < Time.now
      errors.add(:base, '直播时间必须是在未来的时间点')
    end
  end
  
  after_create :create_live_channel_in_qcloud
  def create_live_channel_in_qcloud
    result = Qcloud::LiveVideo.create_channel(self)
    channel_id = result['channel_id']
    if channel_id
      detail_result = Qcloud::LiveVideo.fetch_channel_detail(channel_id)
      if detail_result['code'].to_i == 0
        channel_info = detail_result['channelInfo'].first
        
        source_info = channel_info['upstream_list'].first
        rtmp_push_url = source_info['sourceAddress']

        rtmp_pull_url = channel_info['rtmp_downstream_address']
        hls_pull_url = channel_info['hls_downstream_address']
        
        self.rtmp_push_url = rtmp_push_url
        self.rtmp_pull_url = rtmp_pull_url
        self.hls_pull_url  = hls_pull_url
      end
      self.channel_id = channel_id
      self.save!
      self.close!
    else
      puts '创建频道失败'
      return false
    end
    
  end
  
  # 启动直播
  def open!
    if Qcloud::LiveVideo.open_channels(["#{self.channel_id}"])
      self.closed = false
      self.save!
    end
  end
  
  # 关闭直播
  def close!
    if Qcloud::LiveVideo.close_channels(["#{self.channel_id}"])
      self.closed = true
      self.save!
    end
  end
  
end
