class CreateZipcodes < ActiveRecord::Migration[8.1]
  def change
    create_table :zipcodes do |t|
      t.references :town, null: false, foreign_key: true

      t.string :code, null: false

      t.timestamps
    end

    add_index :zipcodes, :code, unique: true
  end
end
