class CreateLiveVideos < ActiveRecord::Migration
  def change
    create_table :live_videos do |t|
      t.string :images, array: true, default: []
      t.string :title,  null: false
      t.string :body
      t.datetime :lived_at, null: false
      t.string :live_address
      t.string :rtmp_push_url
      t.string :rtmp_pull_url
      t.string :hls_pull_url
      t.string :channel_id
      t.boolean :closed, default: true

      t.timestamps null: false
    end
  end
end
