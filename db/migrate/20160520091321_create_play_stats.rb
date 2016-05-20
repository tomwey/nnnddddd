class CreatePlayStats < ActiveRecord::Migration
  def change
    create_table :play_stats do |t|
      t.string :stream_id
      t.integer :stream_type
      t.string :udid
      t.string :device_model
      t.string :os_version
      t.string :app_version
      t.string :screen_size
      t.string :lang_code
      t.string :country_code

      t.timestamps null: false
    end
  end
end
