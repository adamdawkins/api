require "sorbet-runtime"
require_relative "../../app/values/project"

RSpec.describe Project do
  describe "#po" do
    it "returns the office key and the id" do
      project = described_class.new(api_id: "api_123", office_key: "office_456", id: 789,
                                    status: Project::Status::Draft)
      expect(project.po).to eq("office_456-789")
    end
  end

  describe "#as_json" do
    it "serializes the status as snake_case" do
      project = described_class.new(api_id: "api_123", office_key: "office_456", id: 789,
                                    status: Project::Status::FinanceApproved)
      expect(project.as_json["status"]).to eq("finance_approved")
    end
  end

  describe Project::Status do
    describe ".from_db" do
      it "converts legacy title-cased strings" do
        expect(described_class.from_db("Finance Approved")).to eq(Project::Status::FinanceApproved)
      end

      it "converts legacy strings with uppercased acronyms" do
        expect(described_class.from_db("Awaiting HOA")).to eq(Project::Status::AwaitingHoa)
        expect(described_class.from_db("Awaiting QC Appointment")).to eq(Project::Status::AwaitingQcAppointment)
      end

      it "raises KeyError for an unknown status" do
        expect { described_class.from_db("Not A Status") }.to raise_error(KeyError)
      end
    end

    describe "#to_db" do
      it "converts to legacy title-cased strings" do
        expect(Project::Status::FinanceApproved.to_db).to eq("Finance Approved")
        expect(Project::Status::PaidAndComplete.to_db).to eq("Paid And Complete")
      end

      it "uppercases acronyms" do
        expect(Project::Status::AwaitingHoa.to_db).to eq("Awaiting HOA")
        expect(Project::Status::AwaitingQcAppointment.to_db).to eq("Awaiting QC Appointment")
      end

      it "round trips every status" do
        described_class.values.each do |status|
          expect(described_class.from_db(status.to_db)).to eq(status)
        end
      end
    end
  end
end
