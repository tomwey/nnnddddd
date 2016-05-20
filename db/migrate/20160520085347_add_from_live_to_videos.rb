class AddFromLiveToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :from_live, :boolean, default: false
  end
end
