class PlayStat < ActiveRecord::Base
  # after_create :update_vod_view_count
  # def update_vod_view_count
  #   # $redis.set("#{stream_id}:#{type}")
  #   if stream_type == 2
  #     # 点播
  #     video = Video.find_by(stream_id: self.stream_id)
  #     video.update_attribute(:view_count, video.view_count + 1) unless video.blank?
  #   end
  # end
  
  def stream
    if self.stream_type.to_i == 1
      s_type = 'LiveVideo'
    else
      s_type = 'Video'
    end
    
    klass = s_type.classify.constantize
    
    stream = klass.find_by(stream_id: self.stream_id)
    stream
  end
end
