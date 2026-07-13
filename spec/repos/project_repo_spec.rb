require "rails_helper"

RSpec.describe ProjectRepo do
  describe ".by_api_id" do
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
        project = described_class.by_api_id("prj_123")
        expect(project).to eq (expected_project)
      end
    end

    context "with a legacy status containing an acronym" do
      let(:status) { "Awaiting QC Appointment" }

      it "converts the status to the enum" do
        project = described_class.by_api_id("prj_123")
        expect(project.status).to eq(Orange::Project::Status::AwaitingQcAppointment)
      end
    end

    context "with a status not in the enum" do
      let(:status) { "Unknown Status" }

      it "raises KeyError" do
        expect do
          described_class.by_api_id("prj_123")
        end.to raise_error(KeyError)
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
