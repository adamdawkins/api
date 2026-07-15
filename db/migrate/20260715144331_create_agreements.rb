class CreateAgreements < ActiveRecord::Migration[8.1]
  def change
    create_table :agreements do |t|
      t.references :lender, foreign_key: true, null: false

      t.boolean  :active, default: false, null: false
      t.decimal  :applied_for_amount, precision: 10, scale: 2
      t.decimal  :approved_amount, precision: 10, scale: 2
      t.decimal  :apr, precision: 10, scale: 2
      t.decimal  :bid_percentage, precision: 10, scale: 2
      t.date     :expiry_date
      t.decimal  :monthly_repayment_amount, precision: 10, scale: 2
      t.bigint   :project_id, null: false
      t.string   :status, default: "Applied"
      t.integer  :term
      t.string   :transaction_reference
      t.string   :type, default: "FinanceAgreement"
      t.decimal  :used_amount, precision: 10, scale: 2, default: "0.0"

      t.timestamps
    end
  end
end
