require "rails_helper"

RSpec.describe ProjectRepo do
  describe ".by_api_id" do
    context "with a project with the api id" do
      before do
        office = create(:office_record, key: "NJC")
        lead = create(:lead_record, first_name: "John", last_name: "Doe")
        create(:project_record, api_id: "prj_123",
                                office:,
                                lead:,
                                id: 1,
                                status: "Finance Approved")
      end

      let(:expected_project) do
        customer = Customer.new(first_name: "John", last_name: "Doe")
        Project.new(api_id: "prj_123",
                    office_key: "NJC",
                    id: 1,
                    status: Project::Status::FinanceApproved,
                    customer:)
      end
      it "returns a Project matching the api id" do
        project = described_class.by_api_id("prj_123")
        expect(project).to eq (expected_project)
      end
    end

    context "with a legacy status containing an acronym" do
      before do
        create(:project_record,
               api_id: "prj_123",
               status: "Awaiting QC Appointment")
      end

      it "converts the status to the enum" do
        project = described_class.by_api_id("prj_123")
        expect(project.status).to eq(Project::Status::AwaitingQcAppointment)
      end
    end

    context "with a status not in the enum" do
      before do
        create(:project_record, api_id: "prj_123", status: "Not A Status")
      end

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
