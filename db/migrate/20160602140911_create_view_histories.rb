class CreateViewHistories < ActiveRecord::Migration
  def change
    create_table :view_histories do |t|
      t.references :viewable, polymorphic: true, index: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
