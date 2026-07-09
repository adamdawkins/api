class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
    t.string     :api_id
    t.references :office, foreign_key: true, null: false
    t.references :lead,   foreign_key: true, null: false

    t.decimal  :active_used_amount, precision: 10, scale: 2
    t.datetime :appointment_at, precision: nil
    t.decimal  :apr, precision: 10, scale: 2
    t.decimal  :bid_percentage, precision: 10, scale: 2
    t.string   :cancellation_reason
    t.decimal  :ceiling_price, precision: 10, scale: 2
    t.boolean  :collect_funds_independently
    t.decimal  :collectable_contract_price, precision: 10, scale: 2
    t.decimal  :contract_price, precision: 10, scale: 2
    t.decimal  :down_payment_amount, precision: 10, scale: 2
    t.datetime :finance_approved_at, precision: nil
    t.datetime :finance_docs_signed_and_approved_at, precision: nil
    t.datetime :funds_requested_at, precision: nil
    t.boolean  :high_touch, default: false
    t.boolean  :hoa, default: false
    t.boolean  :hoa_approval_cleared, default: false
    t.integer  :installs_count, default: 0
    t.date     :last_install_date
    t.datetime :payment_collected_at, precision: nil
    t.integer  :payment_method_id
    t.string   :payment_method_name
    t.string   :payment_type
    t.datetime :pending_collection_at, precision: nil
    t.boolean  :pending_legal, default: false
    t.datetime :pre_install_inspection_at, precision: nil
    t.boolean  :qc_eligible
    t.string   :qc_not_required_reason
    t.integer  :rating, limit: 2
    t.datetime :ready_for_install_at, precision: nil
    t.datetime :ready_for_ops_at, precision: nil
    t.boolean  :requires_qc, default: true
    t.datetime :started_at, precision: nil
    t.string   :status, default: "Draft"
    t.integer  :term
    t.integer  :year_home_built

    t.timestamps
    end
  end
end
