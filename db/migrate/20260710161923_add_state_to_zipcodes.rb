class AddStateToZipcodes < ActiveRecord::Migration[8.1]
  def change
    add_column :zipcodes, :state, :string
  end
end
