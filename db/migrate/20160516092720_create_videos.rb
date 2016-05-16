class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :user_id, default: -1 # 0表示是系统上传的
      t.string :title, null: false
      t.string :file, null: false
      t.string :cover_image
      t.integer :view_count, default: 0
      t.integer :likes_count, default: 0

      t.timestamps null: false
    end
    add_index :videos, :user_id
  end
end
