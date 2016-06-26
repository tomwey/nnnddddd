class CreatePayHistories < ActiveRecord::Migration
  def change
    create_table :pay_histories do |t|
      t.string :pay_name
      t.integer :pay_type
      t.decimal :money, precision: 16, scale: 2, default: 0
      t.decimal :fee, precision: 16, scale: 2, default: 0
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
