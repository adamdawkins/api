class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.string  :api_id, null: false
      t.integer :office_id

      t.string  :alternate_phone_number
      t.boolean :bad_credit, default: false
      t.decimal :cost, precision: 10, scale: 2
      t.boolean :dnc, default: false
      t.string  :email
      t.string  :first_name
      t.string  :ineligibile_reason
      t.string  :last_name
      t.boolean :marketing_to_opt_in, default: false
      t.integer :owned_since
      t.string  :phone_number
      t.string  :relation_name
      t.json    :service_types, default: [], null: false
      t.string  :source
      t.string  :spouse
      t.string  :status, default: "Contact"
      t.string  :street_address
      t.string  :wrong_product_reason
      t.string  :zipcode

      t.timestamps
    end
  end
end
