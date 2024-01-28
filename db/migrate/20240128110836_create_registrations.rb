class CreateRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :registrations, id: false do |t|
      t.string :uuid, limit: 36, primary_key: true, null: false
      t.string :activation_code, limit: 6, null: false
      t.references :user, foreign_key: true, type: :integer, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
