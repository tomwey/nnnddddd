class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.integer :from
      t.integer :to
      t.decimal :money, precision: 16, scale: 2, default: 0.01

      t.timestamps null: false
    end
    add_index :grants, :from
    add_index :grants, :to
  end
end
