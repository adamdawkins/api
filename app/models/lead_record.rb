# typed: true

class LeadRecord < ApplicationRecord
  self.table_name = "leads"

  belongs_to :office, class_name: "OfficeRecord", optional: true
end
