# typed: strict

class FinanceProjectRepo
  class << self
    extend T::Sig

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
      record.update!(status: status_to_db(status.serialize))

      Orange::FinanceProject.new(id: record.id,
                                 status: status_from_db(record.status))
    end

    private

    sig { params(value: String).returns(Orange::Project::Status) }
    def status_from_db(value)
      Orange::Project::Status.deserialize(value.downcase.tr(" ", "_"))
    end

    sig { params(value: String).returns(String) }
    def status_to_db(value)
      { "draft" =>  "Draft",
        "cancelled" => "Cancelled",
        "finance_approval" => "Finance Approval",
        "finance_decline" =>  "Finance Decline",
        "finance_approved" =>  "Finance Approved",
        "pending_project_visit" =>  "Pending Project Visit",
        "awaiting_hoa" =>  "Awaiting HOA Approval",
        "in_rescission" =>  "In Rescission",
        "ready_for_ops" => "Ready for Ops",
        "ready_for_install" => "Ready for Install",
        "in_progress" =>  "In Progress",
        "in_service" => "In Service",
        "awaiting_qc_appointment" => "Awaiting QC Appointment",
        "awaiting_qc_project" =>  "Awaiting QC Project",
        "awaiting_project_close_out" => "Awaiting Project Close Out",
        "pending_collection" =>  "Pending Collection",
        "funds_requested" => "Funds Requested",
        "paid_and_complete" =>  "Paid and Complete" }[value]
    end
  end
end
