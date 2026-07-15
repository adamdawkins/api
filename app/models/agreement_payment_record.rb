class AgreementPaymentRecord < ApplicationRecord
  self.table_name = "agreement_payments"

  belongs_to :agreement, class_name: "AgreementRecord", foreign_key: "agreement_id"
end
