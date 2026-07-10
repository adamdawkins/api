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

ActiveRecord::Schema[8.1].define(version: 2026_07_10_161923) do
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

  create_table "projects", force: :cascade do |t|
    t.decimal "active_used_amount", precision: 10, scale: 2
    t.string "api_id"
    t.datetime "appointment_at", precision: nil
    t.decimal "apr", precision: 10, scale: 2
    t.decimal "bid_percentage", precision: 10, scale: 2
    t.string "cancellation_reason"
    t.decimal "ceiling_price", precision: 10, scale: 2
    t.boolean "collect_funds_independently"
    t.decimal "collectable_contract_price", precision: 10, scale: 2
    t.decimal "contract_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.decimal "down_payment_amount", precision: 10, scale: 2
    t.datetime "finance_approved_at", precision: nil
    t.datetime "finance_docs_signed_and_approved_at", precision: nil
    t.datetime "funds_requested_at", precision: nil
    t.boolean "high_touch", default: false
    t.boolean "hoa", default: false
    t.boolean "hoa_approval_cleared", default: false
    t.integer "installs_count", default: 0
    t.date "last_install_date"
    t.integer "lead_id", null: false
    t.integer "office_id", null: false
    t.datetime "payment_collected_at", precision: nil
    t.integer "payment_method_id"
    t.string "payment_method_name"
    t.string "payment_type"
    t.datetime "pending_collection_at", precision: nil
    t.boolean "pending_legal", default: false
    t.datetime "pre_install_inspection_at", precision: nil
    t.boolean "qc_eligible"
    t.string "qc_not_required_reason"
    t.integer "rating", limit: 2
    t.datetime "ready_for_install_at", precision: nil
    t.datetime "ready_for_ops_at", precision: nil
    t.boolean "requires_qc", default: true
    t.datetime "started_at", precision: nil
    t.string "status", default: "Draft"
    t.integer "term"
    t.datetime "updated_at", null: false
    t.integer "year_home_built"
    t.index ["lead_id"], name: "index_projects_on_lead_id"
    t.index ["office_id"], name: "index_projects_on_office_id"
  end

  create_table "towns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_towns_on_name", unique: true
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "state"
    t.integer "town_id", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_zipcodes_on_code", unique: true
    t.index ["town_id"], name: "index_zipcodes_on_town_id"
  end

  add_foreign_key "projects", "leads"
  add_foreign_key "projects", "offices"
  add_foreign_key "zipcodes", "towns"
end
