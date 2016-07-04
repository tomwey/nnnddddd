class AddCategoryIdToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :category_id, :integer
    add_index  :banners, :category_id
  end
end
