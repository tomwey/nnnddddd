class AddFileToSiteConfigs < ActiveRecord::Migration
  def change
    add_column :site_configs, :file, :string
  end
end
