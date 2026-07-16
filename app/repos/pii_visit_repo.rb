class PiiVisitRepo
  class << self
    def get_active_for_project!(project_id)
      record = PiiVisitRecord
        .select(:id, :appointment_at, :status)
        .find_by!(project_id:, status: :pending)

      Orange::PiiVisit.new(id: record.id,
                           appointment_at: record.appointment_at.to_datetime,
                           status: Orange::PiiVisit::Status.deserialize(record.status))
    end

    def update_status(pii_visit_id, status)
      record = PiiVisitRecord.find(pii_visit_id)
      record.update!(status: Orange::PiiVisit::Status.serialize(status))

      Orange::PiiVisit.new(id: record.id,
                           appointment_at: record.appointment_at.to_datetime,
                           status: Orange::PiiVisit::Status.deserialize(record.status))
    end
  end
end
