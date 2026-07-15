# typed: untyped

class AgreementRecord < ApplicationRecord
  self.table_name = "agreements"

  # `type` holds legacy data (e.g. "FinanceAgreement"), not an STI class name
  self.inheritance_column = nil

  belongs_to :lender, class_name: "LenderRecord"
  belongs_to :project, class_name: "ProjectRecord"

  has_many :payments, class_name: "AgreementPaymentRecord", foreign_key: :agreement_id
end
