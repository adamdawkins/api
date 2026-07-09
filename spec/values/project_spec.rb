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
end
