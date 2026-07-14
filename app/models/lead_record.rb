# typed: strict

class LeadRecord < ApplicationRecord
  self.table_name = "leads"

  belongs_to :office, class_name: "OfficeRecord", optional: true
  belongs_to :zipcode_record,
             primary_key: "code",
             foreign_key: "zipcode",
             class_name: "ZipcodeRecord"

  has_many :projects, class_name: "ProjectRecord",
           foreign_key: :lead_id,
           dependent: :destroy
end
