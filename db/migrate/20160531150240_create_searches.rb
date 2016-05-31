class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :keyword, null: false
      t.integer :search_count, default: 0

      t.timestamps null: false
    end
    add_index :searches, :search_count
  end
end
