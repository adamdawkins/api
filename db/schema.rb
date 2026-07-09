# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_09_193809) do
  create_table "leads", force: :cascade do |t|
    t.string "alternate_phone_number"
    t.string "api_id", null: false
    t.boolean "bad_credit", default: false
    t.decimal "cost", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.boolean "dnc", default: false
    t.string "email"
    t.string "first_name"
    t.string "ineligibile_reason"
    t.string "last_name"
    t.boolean "marketing_to_opt_in", default: false
    t.integer "office_id"
    t.integer "owned_since"
    t.string "phone_number"
    t.string "relation_name"
    t.json "service_types", default: [], null: false
    t.string "source"
    t.string "spouse"
    t.string "status", default: "Contact"
    t.string "street_address"
    t.datetime "updated_at", null: false
    t.string "wrong_product_reason"
    t.string "zipcode"
  end

  create_table "offices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.string "name"
    t.datetime "updated_at", null: false
  end
end
