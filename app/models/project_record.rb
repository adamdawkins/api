# typed: strict

class ProjectRecord < ApplicationRecord
  self.table_name = "projects"

  belongs_to :lead, class_name: "LeadRecord"
  belongs_to :office, class_name: "OfficeRecord"
end
