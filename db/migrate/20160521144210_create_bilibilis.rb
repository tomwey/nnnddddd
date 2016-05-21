class CreateBilibilis < ActiveRecord::Migration
  def change
    create_table :bilibilis do |t|
      t.integer :author_id
      t.string :content,   null: false
      t.string :location
      t.string :stream_id, null: false

      t.timestamps null: false
    end
    add_index :bilibilis, :stream_id
  end
end
