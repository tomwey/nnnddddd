class ChangeColumnsForVideos2 < ActiveRecord::Migration
  def change
    # ["id", "user_id", "title", "file", "view_count", "likes_count", "created_at", "updated_at", "sort", "category_id", "stream_id", "from_live"]
    add_column :videos, :cover_image, :string
    add_column :videos, :body, :text
    remove_column :videos, :from_live
    add_column :videos, :msg_count, :integer, default: 0
  end
end
