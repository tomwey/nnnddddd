class ChangeColumnsForVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :cover_image, :string
    add_column :videos, :sort, :integer, default: 0
    add_index :videos, :sort
  end
end
