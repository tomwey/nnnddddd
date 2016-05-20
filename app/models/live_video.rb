class LiveVideo < ActiveRecord::Base
  validates :title, :lived_at, presence: true
  
  mount_uploaders :images, ImagesUploader
  
  scope :fields_for_list, -> { select(:id, :title, :lived_at, :images, :view_count, :stream_id) }
  scope :living, -> { with_state(:living) }
  scope :closed, -> { with_state(:closed) }
  scope :recent, -> { order('id desc') }
  
  # 验证直播时间，必须是在将来的某个时间
  validate :check_lived_at
  def check_lived_at
    if self.lived_at < Time.now
      errors.add(:base, '直播时间必须是在未来的时间点')
    end
  end
    
  # 生成直播流id
  after_create :generate_live_stream_id
  def generate_live_stream_id
    self.update_attribute(:stream_id, SecureRandom.uuid.gsub('-', '')) if self.stream_id.blank?
  end
  
  def state_info
    return '' if state.blank?
    case self.state.to_sym
    when :pending then '未开始'
    when :living  then '直播中'
    when :closed  then '已结束'
    else ''
    end
  end
  
  state_machine initial: :pending do
    state :living # 直播中
    state :closed # 已经关闭
    
    # 开始直播
    event :live do
      transition [:pending, :closed] => :living
    end
    
    # 结束直播
    event :close do
      transition :living => :closed
    end
  end
  
  # after_create :create_live_channel_in_qcloud
  # def create_live_channel_in_qcloud
  #   result = Qcloud::LiveVideo.create_channel(self)
  #   channel_id = result['channel_id']
  #   if channel_id
  #     detail_result = Qcloud::LiveVideo.fetch_channel_detail(channel_id)
  #     if detail_result['code'].to_i == 0
  #       channel_info = detail_result['channelInfo'].first
  #
  #       source_info = channel_info['upstream_list'].first
  #       rtmp_push_url = source_info['sourceAddress']
  #
  #       rtmp_pull_url = channel_info['rtmp_downstream_address']
  #       hls_pull_url = channel_info['hls_downstream_address']
  #
  #       self.rtmp_push_url = rtmp_push_url
  #       self.rtmp_pull_url = rtmp_pull_url
  #       self.hls_pull_url  = hls_pull_url
  #     end
  #     self.channel_id = channel_id
  #     self.save!
  #     self.close!
  #   else
  #     puts '创建频道失败'
  #     return false
  #   end
  #
  # end
  
  # 启动直播
  def open!
    self.live
    # if Qcloud::LiveVideo.open_channels(["#{self.channel_id}"])
    #   self.closed = false
    #   self.save!
    # end
  end
  
  # 关闭直播
  def close!
    self.close
    # if Qcloud::LiveVideo.close_channels(["#{self.channel_id}"])
    #   self.closed = true
    #   self.save!
    # end
  end
  
  def increamt_online_user(n)
    # TODO
  end
  
  # ------------------------------------------------------------------------------- #
  # 返回视频流类型
  def type
    1
  end
  
  def rtmp_push_url
    return "" if stream_id.blank?
    "rtmp://push.yaying.tv/zgnx/#{stream_id}"
  end
  def rtmp_url
    return "" if stream_id.blank?
    "rtmp://live1.yaying.tv/zgnx/#{stream_id}"
  end
  
  def hls_url
    return "" if stream_id.blank?
    "http://live2.yaying.tv/zgnx/#{stream_id}/playlist.m3u8"
  end
  
  def vod_url
    return "" if stream_id.blank?
    "http://ulive-record.ufile.ucloud.cn/#{stream_id}.mp4"
  end
  
  def live_time
    lived_at.strftime('%Y-%m-%d %H:%M:%S')
  end
  
  def cover_image
    return "" if images.blank? or images.empty?
    images.first.url(:thumb)
  end
  
  def detail_images
    arr = []
    images.each do |image|
      arr << image.url(:large)
    end
    arr
  end
  # ------------------------------------------------------------------------------- #
  
end
