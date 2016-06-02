class AddPlaybackProgressToViewHistories < ActiveRecord::Migration
  def change
    add_column :view_histories, :playback_progress, :integer
  end
end
