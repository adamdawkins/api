class CreateTowns < ActiveRecord::Migration[8.1]
  def change
    create_table :towns do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :towns, :name, unique: true
  end
end
