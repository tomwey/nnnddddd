class AddViewCountToLiveVideos < ActiveRecord::Migration
  def change
    add_column :live_videos, :view_count, :integer, default: 0
  end
end
