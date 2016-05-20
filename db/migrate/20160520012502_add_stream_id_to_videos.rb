class AddStreamIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :stream_id, :string
    add_index  :videos, :stream_id, unique: true
  end
end
