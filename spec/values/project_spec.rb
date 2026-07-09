require "sorbet-runtime"
require_relative "../../app/values/project"

RSpec.describe Project do
  describe "#po" do
    it "returns the office key and the id" do
      project = described_class.new(api_id: "api_123", office_key: "office_456", id: 789)
      expect(project.po).to eq("office_456-789")
    end
  end
end
