class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.integer :role
      t.text :content
      t.integer :response_number

      t.timestamps
    end
  end
end
