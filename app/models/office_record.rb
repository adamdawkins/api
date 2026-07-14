# typed: strict

class OfficeRecord < ApplicationRecord
  self.table_name = "offices"

  has_many :leads,
           class_name: "LeadRecord",
           foreign_key: :office_id,
           dependent: :destroy
  has_many :projects,
           class_name: "ProjectRecord",
           foreign_key: :office_id,
           dependent: :destroy
end
