class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
