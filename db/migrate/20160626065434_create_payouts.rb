class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.decimal :money, precision: 16, scale: 2, null: false
      t.decimal :fee, precision: 16, scale: 2, default: 0
      t.string :card_no, null: false
      t.boolean :payed, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :payouts, :card_no, unique: true
  end
end
