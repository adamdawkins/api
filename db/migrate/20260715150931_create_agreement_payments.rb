class CreateAgreementPayments < ActiveRecord::Migration[8.1]
  def change
    create_table :agreement_payments do |t|
      t.references :agreement, foreign_key: true, null: false

      t.decimal :amount, precision: 10, scale: 2, default: 0.0, null: false
      t.date    :collected_date

      t.timestamps
    end
  end
end
