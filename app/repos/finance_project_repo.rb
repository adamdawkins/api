# typed: strict

class FinanceProjectRepo
  class << self
    extend T::Sig
    include ProjectStatusMap

    sig { params(api_id: String).returns(Orange::FinanceProject) }
    def by_api_id(api_id)
      record = ProjectRecord.find_by!(api_id:)

      Orange::FinanceProject.new(id: record.id,
                                 status: status_from_db(record.status))
    end

    sig do
      params(project_id: Integer, status: Orange::Project::Status).returns(Orange::FinanceProject)
    end
    def update_status(project_id, status)
      record = ProjectRecord.find(project_id)
      record.update!(status: status_to_db(status))

      Orange::FinanceProject.new(id: record.id,
                                 status: status_from_db(record.status))
    end
  end
end
