class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :author
      t.string :content, null: false

      t.timestamps null: false
    end
  end
end
