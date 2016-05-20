class ChangeColumnForLiveVideos < ActiveRecord::Migration
  def change
    change_column :live_videos, :state, :string, default: :pending
  end
end
