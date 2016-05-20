class ChangeColumnsForLiveVideos < ActiveRecord::Migration
  def change
    remove_column :live_videos, :rtmp_push_url
    remove_column :live_videos, :rtmp_pull_url
    remove_column :live_videos, :hls_pull_url
    remove_column :live_videos, :channel_id
    remove_column :live_videos, :closed
    
    add_column :live_videos, :state, :string
    
    add_column :live_videos, :stream_id, :string
    add_index  :live_videos, :stream_id, unique: true
    
    add_column :live_videos, :provider_id, :integer
    add_index  :live_videos, :provider_id
  end
end
