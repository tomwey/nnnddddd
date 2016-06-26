class ChangeColumnsForPayouts < ActiveRecord::Migration
  def change
    remove_column :payouts, :payed
    add_column :payouts, :payed_at, :datetime
  end
end
