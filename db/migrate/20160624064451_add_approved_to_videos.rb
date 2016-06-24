class AddApprovedToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :approved, :boolean, default: true
  end
end
