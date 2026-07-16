require "rails_helper"

RSpec.describe ProjectRepo do
  describe ".get_by_api_id!" do
    before do
      office = create(:office_record, key: "NJC")
      town = create(:town_record, name: "Philadelphia")
      zipcode_record = create(:zipcode_record,
                              code: "12345",
                              town:,
                              state: "PA")

      lead = create(:lead_record,
                    street_address: "123 Main St",
                    first_name: "John",
                    last_name: "Doe",
                    zipcode_record:)
      create(:project_record, api_id: "prj_123",
             office:,
             lead:,
             id: 1,
             status:)
    end

    let(:status) { "Finance Approved" }

    let(:expected_project) do
      address = Orange::Address.new(line1: "123 Main St",
                                    city: "Philadelphia",
                                    state: Orange::Address::State::PA,
                                    zipcode: Orange::Zipcode.new("12345"))
      customer = Orange::Customer.new(first_name: "John", last_name: "Doe", address:)

      Orange::Project.new(api_id: "prj_123",
                          office_key: "NJC",
                          id: 1,
                          status: Orange::Project::Status::FinanceApproved,
                          customer:)
    end
    context "with a project with the api id" do
      it "returns a Project matching the api id" do
        project = described_class.get_by_api_id!("prj_123")
        expect(project).to eq (expected_project)
      end
    end

    context "without a project with the api id" do
      it "raises ActiveRecord::RecordNotFound" do
        expect do
          described_class.get_by_api_id!("prj_999")
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
