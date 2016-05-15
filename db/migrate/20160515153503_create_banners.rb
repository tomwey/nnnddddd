class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :image
      t.string :link
      t.integer :sort, default: 0

      t.timestamps null: false
    end
  end
end
