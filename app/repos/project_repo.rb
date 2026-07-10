class ProjectRepo
  def self.by_api_id(api_id)
    record = ProjectRecord
             .joins(:office, :lead)
             .select(:id, :api_id, :status,
                     offices: { key: :office_key },
                     leads: [ :first_name, :last_name ])
             .find_by!(api_id:)

    Project.new(api_id: record.api_id,
                office_key: record.office_key,
                id: record.id,
                status: status_from_db(record.status),
                customer: Customer.new(first_name: record.first_name, last_name: record.last_name)
               )
  end

  # DB stores legacy title-cased strings with uppercased acronyms,
  # e.g. "Finance Approved", "Awaiting HOA", "Awaiting QC Appointment"
  def self.status_from_db(value) = Project::Status.deserialize(value.downcase.tr(" ", "_"))
  private_class_method :status_from_db
end
