class PiiVisitRecord < ApplicationRecord
  self.table_name = "pii_visits"

  belongs_to :project, class_name: "ProjectRecord", foreign_key: :project_id

  enum :status,
        pending: "Pending",
        cancelled: "Cancelled",
        no_demo: "No Demo",
        finished: "Finished"
end
