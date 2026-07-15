# typed: strict

class ProjectRecord < ApplicationRecord
  self.table_name = "projects"

  belongs_to :lead,   class_name: "LeadRecord"
  belongs_to :office, class_name: "OfficeRecord"

  has_many :agreements, class_name: "AgreementRecord", foreign_key: :project_id
end
