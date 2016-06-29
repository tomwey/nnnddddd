class AddOpenedAndUserUploadToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :opened, :boolean, default: true
    add_column :categories, :user_upload, :boolean, default: false
  end
end
