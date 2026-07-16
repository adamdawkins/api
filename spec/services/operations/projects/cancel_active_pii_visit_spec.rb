require "rails_helper"

RSpec.describe Operations::Projects::CancelActivePiiVisit do
  subject(:operation) do
    described_class.new(pii_visit_repo:,
                        optimo_route_deleter:)
  end

  # Arguments
  let(:project_id) { 2 }


  # Dependencies
  let(:pii_visit_repo) { class_double("PiiVisitRepo") }
  let(:optimo_route_deleter) { class_double("Operations::Projects::DeleteOptimoRoute") }

  # Results
  let(:pii_visit) { Orange::PiiVisit.new(id: 1, status: Orange::PiiVisit::Status::Pending) }
  let(:cancelled_pii_visit) { pii_visit.with(status: Orange::PiiVisit::Status::Cancelled) }

  describe "#call" do
    before do
      allow(pii_visit_repo).to receive(:get_active_for_project!)
        .with(project_id)
        .and_return(pii_visit)

      allow(pii_visit_repo).to receive(:update_status)
        .with(1, Orange::PiiVisit::Status::Cancelled)
        .and_return(cancelled_pii_visit)

      allow(optimo_route_deleter).to receive(:perform_later).with(project_id)
    end

    it "updates the active pii visit's status to cancelled" do
      operation.call(project_id)

      expect(pii_visit_repo).to have_received(:update_status)
        .with(1, Orange::PiiVisit::Status::Cancelled)
    end

    it "deletes the OptimoRoute for the project" do
      operation.call(project_id)

      expect(optimo_route_deleter).to have_received(:perform_later).with(project_id)
    end

    it "returns the modified pii visit" do
      expect(operation.call(project_id)).to eq cancelled_pii_visit
    end
  end

  describe ".perform_later" do
    before { allow(OperationJob).to receive(:perform_later) }

    it "calls the operation job with self and the args" do
      described_class.perform_later(project_id)

      expect(OperationJob).to have_received(:perform_later).with(
        project_id,
        operation: described_class
      )
    end
  end
end
