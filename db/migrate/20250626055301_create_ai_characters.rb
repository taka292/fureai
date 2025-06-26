class CreateAiCharacters < ActiveRecord::Migration[7.2]
  def change
    create_table :ai_characters do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :personality

      t.timestamps
    end
  end
end
