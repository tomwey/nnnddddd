require 'qiniu'
require 'rest-client'
class LiveVideo < ActiveRecord::Base
  validates :title, :body, :cover_image, presence: true
  
  has_many :likes, as: :likeable
  has_many :favorites, as: :favoriteable
  has_many :view_histories, as: :viewable
  
  mount_uploader :cover_image, CoverImageUploader
  # mount_uploader :video_file, VideoUploader
  
  scope :fields_for_list, -> { select(:id, :title, :created_at, :cover_image, :view_count, :stream_id) }
  scope :living, -> { with_state(:living) }
  scope :closed, -> { with_state(:closed) }
  scope :hot,    -> { order('view_count desc') }
  scope :recent, -> { order('id desc') }
  
  # 生成直播流id
  after_create :generate_live_stream_id
  def generate_live_stream_id
    self.update_attribute(:stream_id, SecureRandom.uuid.gsub('-', '')) if self.stream_id.blank?
  end
  
  # 搜索次数统计
  def add_search_count
    self.class.increment_counter(:search_count, self.id)
  end
  
  def self.search(keyword)
    where('title like :keyword or body like :keyword', keyword: "%#{keyword}%")
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
  
  def video_file_url
    return '' if self.video_file.blank?
    origin_file_url = 'http://cdn.yaying.tv' + "/uploads/live_video/" + self.video_file
    Qiniu::Auth.authorize_download_url(origin_file_url)
  end
  
  state_machine initial: :pending do
    state :living # 直播中
    state :closed # 已经关闭
    
    # 开始直播
    event :live do
      transition [:pending, :closed] => :living
    end
    
    # 结束直播
    after_transition :living => :closed do |live_video, transition|
      # 将用户在线数更新到view_count
      live_video.view_count = live_video.online_users_count
      live_video.save
    end
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
    $redis.del(stream_id)
  end
  
  def update_online_user_count(n)
    if $redis.get(stream_id).blank?
      $redis.set(stream_id, self.view_count)
    end
    
    count = $redis.get(stream_id).to_i
    if count + n > 0
      count = count + n
      $redis.set(stream_id, count)
    end
    
    # 通知消息
    # $mqtt.publish(stream_id, $redis.get(stream_id))
    params = {
      'method' => 'publish',
      'appkey' => SiteConfig.yb_app_key,
      'seckey' => SiteConfig.yb_secret_key,
      'topic'  => stream_id,
      'msg'    => $redis.get(stream_id)
    }
    RestClient.post "http://rest.yunba.io:8080", params.to_json, :content_type => :json, :accept => :json 
    
    # curl -l -H "Content-type: application/json" -X POST -d '{"method":"publish", "appkey":"XXXXXXXXXXXXXXXXXXXXXXX", "seckey":"sec-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX", "topic":"news", "msg":"good news"}' http://rest.yunba.io:8080
    
    # 每新增10个用户存一次数据库
    if count - self.view_count > 10
      self.update_attribute(:view_count, count)
    end
    
  end
  
  def online_users_count
    ($redis.get(stream_id) || self.view_count).to_i
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
  
  # def vod_url
  #   return "" if stream_id.blank?
  #   "http://ulive-record.ufile.ucloud.cn/#{stream_id}.mp4"
  # end
  # 
  # def live_time
  #   lived_at.strftime('%Y-%m-%d %H:%M:%S')
  # end
  # 
  # def cover_image
  #   return "" if images.blank? or images.empty?
  #   images.first.url(:thumb)
  # end
  # 
  # def detail_images
  #   arr = []
  #   images.each do |image|
  #     arr << image.url(:large)
  #   end
  #   arr
  # end
  # ------------------------------------------------------------------------------- #
  
end
