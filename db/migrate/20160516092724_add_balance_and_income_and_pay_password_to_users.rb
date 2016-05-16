class AddBalanceAndIncomeAndPayPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal,precision: 16, scale: 2, default: 0
    add_column :users, :income, :decimal, precision: 16, scale: 2, default: 0
    add_column :users, :pay_password, :string
  end
end
