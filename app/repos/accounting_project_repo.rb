# typed: strict

class AccountingProjectRepo
  class << self
    extend T::Sig
    include ProjectStatusMap

    sig { params(api_id: String).returns(Orange::AccountingProject) }
    def get_by_api_id!(api_id)
      accounting_project(ProjectRecord.select(:id,
                                              :status,
                                              :collect_funds_independently,
                                              :qc_for_project_id).find_by!(api_id:))
    end

    sig { params(api_id: String).returns(Orange::AccountingProject) }
    def by_api_id(api_id)
      accounting_project(ProjectRecord.select(:id,
                                              :status,
                                              :collect_funds_independently,
                                              :qc_for_project_id).find_by!(api_id:))
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
    sig { params(record: T.untyped).returns(T.nilable(ProjectRecord)) }
    def related_record_for(record)
      if record.qc_for_project_id
        ProjectRecord.select(:id).find(record.qc_for_project_id)
      else
        ProjectRecord.select(:id).find_by(qc_for_project_id: record.id)
      end
    end

    # MAX(payment id) stands in for "has any payment", so one query covers
    # every agreement's paid status without duplicating multi-payment rows.
    sig { params(record: T.untyped).returns(T::Array[Orange::Agreement]) }
    def agreements(record)
      record.agreements
            .left_joins(:payments)
            .group(:id)
            .select(:id, "MAX(agreement_payments.id) AS payment_id")
            .map { |row| Orange::Agreement.new(id: row.id, paid: row.payment_id.present?) }
    end
  end
end
