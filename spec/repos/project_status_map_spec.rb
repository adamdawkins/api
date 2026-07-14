require "rails_helper"

RSpec.describe ProjectStatusMap do
  mappings = {
    Orange::Project::Status::Draft => "Draft",
    Orange::Project::Status::Cancelled => "Cancelled",
    Orange::Project::Status::FinanceApproval => "Finance Approval",
    Orange::Project::Status::FinanceDecline => "Finance Decline",
    Orange::Project::Status::FinanceApproved => "Finance Approved",
    Orange::Project::Status::PendingProjectVisit => "Pending Project Visit",
    Orange::Project::Status::AwaitingHoaApproval => "Awaiting HOA Approval",
    Orange::Project::Status::InRescission => "In Rescission",
    Orange::Project::Status::ReadyForOps => "Ready For Ops",
    Orange::Project::Status::ReadyForInstall => "Ready For Install",
    Orange::Project::Status::InProgress => "In Progress",
    Orange::Project::Status::InService => "In Service",
    Orange::Project::Status::AwaitingQcAppointment => "Awaiting QC Appointment",
    Orange::Project::Status::AwaitingQcProject => "Awaiting QC Project",
    Orange::Project::Status::AwaitingProjectCloseOut => "Awaiting Project Close Out",
    Orange::Project::Status::PendingCollection => "Pending Collection",
    Orange::Project::Status::FundsRequested => "Funds Requested",
    Orange::Project::Status::PaidAndComplete => "Paid And Complete"
  }

  describe ".status_to_db" do
    mappings.each do |status, db_value|
      it "maps #{status.serialize} to '#{db_value}'" do
        expect(described_class.status_to_db(status)).to eq(db_value)
      end
    end
  end

  describe ".status_from_db" do
    mappings.each do |status, db_value|
      it "maps '#{db_value}' to #{status.serialize}" do
        expect(described_class.status_from_db(db_value)).to eq(status)
      end
    end
  end

  it "round-trips every status" do
    Orange::Project::Status.values.each do |status|
      expect(described_class.status_from_db(described_class.status_to_db(status))).to eq(status)
    end
  end
end
