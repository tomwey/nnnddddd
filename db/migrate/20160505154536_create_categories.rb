class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :icon
      t.integer :sort, default: 0

      t.timestamps null: false
    end
    add_index :categories, :sort
  end
end
