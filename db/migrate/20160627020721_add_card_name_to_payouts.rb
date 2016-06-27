class AddCardNameToPayouts < ActiveRecord::Migration
  def change
    add_column :payouts, :card_name, :string
  end
end
