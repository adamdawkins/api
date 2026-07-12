require "rails_helper"

RSpec.describe "Projects finance API", type: :request do
  describe "PATCH /api/v1/projects/:api_id/finance/decline" do
    subject(:req) { patch "/api/v1/projects/prj_123/finance/decline" }

    context "with a project" do
      before { create(:project_record, api_id: "prj_123", status:) }

      let(:status) { "Finance Approval" }

      context "with finance approval status" do
        let(:status) { "Finance Approval" }

        it "returns ok" do
          req

          expect(response).to have_http_status(200)
        end

        it "returns a project with finance declined status" do
          req

          json = JSON.parse(response.body)

          expect(json["project"]["status"]).to eq("finance_decline")
        end
      end
      context "with any other project status" do
        let(:status) { "Ready for Ops" }

        it "returns a 422" do
          req

          expect(response).to have_http_status(422)
        end

        it "indicates that project's with this status cannot be declined" do
          req

          json = JSON.parse(response.body)

          expect(json["error"]).to eq("wrong_status")
        end
      end
    end

    context "without a project" do
      it "returns a 404" do
        req

        expect(response).to have_http_status(404)
      end
    end
  end
end
