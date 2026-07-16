class CreatePiiVisits < ActiveRecord::Migration[8.1]
  def change
    create_table :pii_visits do |t|
      t.references :project, null: false, foreign_key: true
      t.datetime :appointment_at
      t.string :status, null: false, default: "pending"
      t.timestamps
    end
  end
end
