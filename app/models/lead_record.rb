# typed: true

class LeadRecord < ApplicationRecord
  self.table_name = "leads"

  belongs_to :office, class_name: "OfficeRecord", optional: true

  has_many :projects, class_name: "ProjectRecord",
           foreign_key: :lead_id,
           dependent: :destroy
end
