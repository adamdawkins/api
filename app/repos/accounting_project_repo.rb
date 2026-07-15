# typed: strict

class AccountingProjectRepo
  class << self
    extend T::Sig
    include ProjectStatusMap

    sig { params(api_id: String).returns(Orange::AccountingProject) }
    def by_api_id(api_id)
      accounting_project(ProjectRecord.find_by!(api_id:))
    end

    sig do
      params(project_id: Integer, status: Orange::Project::Status).returns(Orange::AccountingProject)
    end
    def update_status(project_id, status)
      record = ProjectRecord.find(project_id)
      record.update!(status: status_to_db(status))

      accounting_project(record)
    end

    private

    sig { params(record: T.untyped).returns(Orange::AccountingProject) }
    def accounting_project(record)
      related_record = related_record_for(record)

      Orange::AccountingProject.new(
        id: record.id,
        collect_funds_independently: !!record.collect_funds_independently,
        qc: record.qc_for_project_id.present?,
        related_project_id: related_record&.id,
        status: status_from_db(record.status),
        agreements: agreements(record),
        related_agreements: related_record ? agreements(related_record) : [])
    end

    # A QC project points at its parent via qc_for_project_id; a non-QC
    # project's related project is the QC project pointing back at it.
    #
    # `record` can't be typed as `ProjectRecord` because ActiveRecord column
    # accessors like `qc_for_project_id` are defined dynamically and aren't
    # in any RBI.
    sig { params(record: T.untyped).returns(T.nilable(ProjectRecord)) }
    def related_record_for(record)
      if record.qc_for_project_id
        ProjectRecord.find(record.qc_for_project_id)
      else
        ProjectRecord.find_by(qc_for_project_id: record.id)
      end
    end

    sig { params(record: ProjectRecord).returns(T::Array[Orange::Agreement]) }
    def agreements(record)
      AgreementRecord.where(project_id: record.id).map do |agreement|
        Orange::Agreement.new(
          id: agreement.id,
          paid: AgreementPaymentRecord.exists?(agreement_id: agreement.id))
      end
    end
  end
end
