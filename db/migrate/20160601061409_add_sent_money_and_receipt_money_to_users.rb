class AddSentMoneyAndReceiptMoneyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sent_money, :decimal,precision: 16, scale: 2, default: 0.00
    add_column :users, :receipt_money, :decimal, precision: 16, scale: 2, default: 0.00
    remove_column :users, :income
  end
end
