class AddSearchCount < ActiveRecord::Migration
  def change
    add_column :videos, :search_count, :integer, default: 0, index: true
    add_column :live_videos, :search_count, :integer, default: 0, index: true
  end
end
