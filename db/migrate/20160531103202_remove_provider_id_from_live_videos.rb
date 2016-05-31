class RemoveProviderIdFromLiveVideos < ActiveRecord::Migration
  def change
    remove_index :live_videos, :provider_id
    remove_column :live_videos, :provider_id
  end
end
