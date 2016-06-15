class CreateSearchHistories < ActiveRecord::Migration
  def change
    create_table :search_histories do |t|
      t.references :search, index: true
      t.references :searchable, polymorphic: true, index: true
      t.integer :search_count, default: 0 # 同一个关键字搜索到同一个视频或直播，在搜索历史中只保留一份，但是需要统计被搜到的次数

      t.timestamps null: false
    end
  end
end
