require "rails_helper"

RSpec.describe FinanceProjectRepo do
  describe ".by_api_id" do
    before { create(:project_record, id: 1, api_id: "prj_123", status:) }

    let(:status) { "Finance Approval" }

    let(:expected_project) do
      Orange::FinanceProject.new(id: 1, status: Orange::Project::Status::FinanceApproval)
    end

    context "with a project with the api id" do
      it "returns an Orange::FinanceProject matching the api id" do
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

  describe ".update_status" do
    let(:project_record) { create(:project_record, id: 1, status: "Finance Approval") }
    let(:expected_project) do
      Orange::FinanceProject.new(id: 1, status: Orange::Project::Status::FinanceDecline)
    end

    it "updates the status of the project record" do
      described_class.update_status(project_record.id, Orange::Project::Status::FinanceDecline)

      expect(ProjectRecord.find(project_record.id).status).to eq("Finance Decline")
    end

    it "returns a FinanceProject with the updated status" do
      updated_project = described_class.update_status(project_record.id,
                                                      Orange::Project::Status::FinanceDecline)

      expect(updated_project).to eq(expected_project)
  end
  end
end
