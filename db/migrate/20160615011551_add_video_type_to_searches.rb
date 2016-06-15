class AddVideoTypeToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :video_type, :integer
  end
end
