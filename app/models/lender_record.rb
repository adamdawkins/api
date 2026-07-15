class LenderRecord < ApplicationRecord
  self.table_name = "lenders"

  has_many :agreements,
           class_name: "AgreementRecord",
           foreign_key: :lender_id,
           inverse_of: :lender,
           dependent: :restrict_with_error
end
