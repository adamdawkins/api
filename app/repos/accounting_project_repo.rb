# typed: strict

class AccountingProjectRepo
  class << self
    extend T::Sig
    include ProjectStatusMap

    sig { params(api_id: String).returns(Orange::AccountingProject) }
    def by_api_id(api_id)
      record = ProjectRecord.find_by!(api_id:)
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

    private

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
