class AddFavoritesCount < ActiveRecord::Migration
  def change
    add_column :videos, :favorites_count, :integer, default: 0
    add_column :live_videos, :favorites_count, :integer, default: 0
  end
end
