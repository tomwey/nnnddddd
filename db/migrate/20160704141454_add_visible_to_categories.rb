class AddVisibleToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :visible, :boolean, default: true
  end
end
