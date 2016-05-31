class ChangeColumnsForLiveVideos2 < ActiveRecord::Migration
  def change
    # ["id", "images", "title", "body", "lived_at", "live_address", "created_at", "updated_at", "view_count", "state", "stream_id"]
    change_column :live_videos, :body, :text
    remove_column :live_videos, :images
    remove_column :live_videos, :lived_at
    remove_column :live_videos, :live_address
    add_column :live_videos, :cover_image, :string
    add_column :live_videos, :video_file, :string
    add_column :live_videos, :likes_count, :integer, default: 0
    add_column :live_videos, :msg_count, :integer, default: 0
  end
end
