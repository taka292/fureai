class CreateMentalConditions < ActiveRecord::Migration[7.2]
  def change
    create_table :mental_conditions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :mental_state
      t.integer :physical_state
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
