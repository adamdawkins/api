class ProjectRepo
  def self.by_api_id(api_id)
    record = ProjectRecord.includes(:office).find_by!(api_id:)
    Project.new(api_id: record.api_id,
                office_key: record.office.key,
                id: record.id,
                status: status_from_db(record.status))
  end

  # DB stores legacy title-cased strings with uppercased acronyms,
  # e.g. "Finance Approved", "Awaiting HOA", "Awaiting QC Appointment"
  def self.status_from_db(value) = Project::Status.deserialize(value.downcase.tr(" ", "_"))
  private_class_method :status_from_db
end
