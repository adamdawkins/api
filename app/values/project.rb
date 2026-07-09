# typed: true

class Project < T::Struct
  extend T::Sig
  include StructEquality

  class Status < T::Enum
    enums do
      Draft = new("draft")
      Cancelled = new("cancelled")
      FinanceApproval = new("finance_approval")
      FinanceDecline = new("finance_decline")
      FinanceApproved = new("finance_approved")
      PendingProjectVisit = new("pending_project_visit")
      AwaitingHoa = new("awaiting_hoa")
      InRescission = new("in_rescission")
      ReadyForOps = new("ready_for_ops")
      ReadyForInstall = new("ready_for_install")
      InProgress = new("in_progress")
      InService = new("in_service")
      AwaitingQcAppointment = new("awaiting_qc_appointment")
      AwaitingQcProject = new("awaiting_qc_project")
      AwaitingProjectCloseOut = new("awaiting_project_close_out")
      PendingCollection = new("pending_collection")
      FundsRequested = new("funds_requested")
      PaidAndComplete = new("paid_and_complete")
    end
  end

  const :api_id, String
  const :office_key, String
  const :id, Integer
  const :status, Status

  def po = "#{office_key}-#{id}"

  def as_json(*) = serialize.merge("po" => po)
end
