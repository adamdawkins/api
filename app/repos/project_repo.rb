class ProjectRepo
  def self.by_api_id(api_id)
    record = ProjectRecord.includes(:office).find_by!(api_id:)
    Project.new(api_id: record.api_id,
                office_key: record.office.key,
                id: record.id,
                status: Project::Status.from_db(record.status))
  end
end
