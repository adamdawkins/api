require "rails_helper"

RSpec.describe ProjectRepo do
  describe ".by_api_id" do
    context "with a project with the api id" do
      before do
        office = create(:office_record, key: "NJC")
        create(:project_record, api_id: "prj_123", office:, id: 1)
      end
      it "returns a Project matching the api id" do
        project = described_class.by_api_id("prj_123")
        expect(project).to eq (Project.new(api_id: "prj_123",
                                           office_key: "NJC",
                                           id: 1))
      end
    end

    context "without a project with the api id" do
      it "raises ActiveRecord::RecordNotFound" do
        expect do
          described_class.by_api_id("prj_999")
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
