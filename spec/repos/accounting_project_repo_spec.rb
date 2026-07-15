require "rails_helper"

RSpec.describe AccountingProjectRepo do
  describe ".by_api_id" do
    context "with a project with the api id" do
      context "with a qc project" do
        let!(:project_record) do
          create(:project_record, api_id: "prj_123",
                                  status: "Funds Requested",
                                  qc_for_project_id: parent_project.id)
        end

        let(:parent_project) { create(:project_record) }

        let!(:agreement) { create(:agreement_record, project_id: project_record.id) }
        let!(:parent_agreement) { create(:agreement_record, project_id: parent_project.id) }

        before { create(:agreement_payment_record, agreement: parent_agreement) }

        let(:expected_project) do
          Orange::AccountingProject.new(
            id: project_record.id,
            related_project_id: parent_project.id,
            collect_funds_independently: false,
            qc: true,
            status: Orange::Project::Status::FundsRequested,
            agreements: [ Orange::Agreement.new(id: agreement.id, paid: false) ],
            related_agreements: [ Orange::Agreement.new(id: parent_agreement.id, paid: true) ]
          )
        end

        it "returns the project with the parent project as the related project" do
          expect(described_class.by_api_id("prj_123")).to eq expected_project
        end
      end

      context "with a non-qc project" do
        let!(:project_record) do
          create(:project_record, api_id: "prj_123", status: "Funds Requested")
        end

        let!(:paid_agreement) { create(:agreement_record, project_id: project_record.id) }
        let!(:unpaid_agreement) { create(:agreement_record, project_id: project_record.id) }

        before { create(:agreement_payment_record, agreement: paid_agreement) }

        context "with a related qc project" do
          let!(:qc_project) do
            create(:project_record, qc_for_project_id: project_record.id)
          end

          let!(:qc_agreement) { create(:agreement_record, project_id: qc_project.id) }

          before { create(:agreement_payment_record, agreement: qc_agreement) }

          let(:expected_project) do
            Orange::AccountingProject.new(
              id: project_record.id,
              related_project_id: qc_project.id,
              collect_funds_independently: false,
              qc: false,
              status: Orange::Project::Status::FundsRequested,
              agreements: [
                Orange::Agreement.new(id: paid_agreement.id, paid: true),
                Orange::Agreement.new(id: unpaid_agreement.id, paid: false)
              ],
              related_agreements: [ Orange::Agreement.new(id: qc_agreement.id, paid: true) ]
            )
          end

          it "returns the project with the qc project as the related project" do
            expect(described_class.by_api_id("prj_123")).to eq expected_project
          end
        end

        context "without a related qc project" do
          let(:expected_project) do
            Orange::AccountingProject.new(
              id: project_record.id,
              related_project_id: nil,
              collect_funds_independently: false,
              qc: false,
              status: Orange::Project::Status::FundsRequested,
              agreements: [
                Orange::Agreement.new(id: paid_agreement.id, paid: true),
                Orange::Agreement.new(id: unpaid_agreement.id, paid: false)
              ],
              related_agreements: []
            )
          end

          it "returns the project with no related project" do
            expect(described_class.by_api_id("prj_123")).to eq expected_project
          end
        end
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
