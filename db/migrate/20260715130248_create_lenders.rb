class CreateLenders < ActiveRecord::Migration[8.1]
  def change
  create_table "lenders", force: :cascade do |t|
    t.boolean :active, default: true
    t.integer :finance_expiration_number_of_days
    t.string  :name
  end
  end
end
