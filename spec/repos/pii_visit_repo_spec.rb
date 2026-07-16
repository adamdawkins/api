require "rails_helper"

RSpec.describe PiiVisitRepo do
  describe ".get_active_for_project!" do
    let(:project) { create(:project_record) }
    let!(:pii_visit) { create(:pii_visit_record, project:, status: "Pending") }

    let(:expected_pii_visit) do
      Orange::PiiVisit.new(id: pii_visit.id,
                           appointment_at: pii_visit.appointment_at.to_datetime,
                           status: Orange::PiiVisit::Status::Pending)
    end

    it "retrieves the active PII visit for the given project_id" do
      result = PiiVisitRepo.get_active_for_project!(project.id)

      expect(result).to eq(expected_pii_visit)
    end
  end

  describe ".update_status" do
    let!(:pii_visit) { create(:pii_visit_record, status: "Pending") }

    let(:expected_pii_visit) do
      Orange::PiiVisit.new(id: pii_visit.id,
                           appointment_at: pii_visit.appointment_at.to_datetime,
                           status: Orange::PiiVisit::Status::Cancelled)
    end

    it "updates the status of the pii visit record" do
      described_class.update_status(pii_visit.id, Orange::PiiVisit::Status::Cancelled)

      expect(PiiVisitRecord.find(pii_visit.id).status).to eq("cancelled")
    end

    it "returns a PiiVisit with the updated status" do
      result = described_class.update_status(pii_visit.id, Orange::PiiVisit::Status::Cancelled)

      expect(result).to eq(expected_pii_visit)
    end
  end
end
