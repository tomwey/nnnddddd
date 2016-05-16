class RenameColumnForUsers < ActiveRecord::Migration
  def change
    rename_column :users, :pay_password, :pay_password_digest
  end
end
