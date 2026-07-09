class CreateOffices < ActiveRecord::Migration[8.1]
  def change
    create_table :offices do |t|
      t.string :key
      t.string :name
      t.timestamps
    end
  end
end
