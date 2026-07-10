class ProjectRepo
  class << self
  def by_api_id(api_id)
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
                customer: customer(record)
               )
  end

  private

  def status_from_db(value) = Project::Status.deserialize(value.downcase.tr(" ", "_"))

  def customer(record)
    Customer.new(first_name: record.first_name, last_name: record.last_name)
  end
  end
end
