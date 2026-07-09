require "rails_helper"

RSpec.describe 'Projects API', type: :request do
  describe "GET /api/v1/projects/:api_id" do
    subject(:req) { get "/api/v1/projects/prj_123" }
    context "with a matching project" do
      before { create(:project_record, api_id: "prj_123") }

      it "returns a 200" do
        req

        expect(response).to have_http_status(200)
      end

      it "returns the project" do
        req

        json = JSON.parse(response.body)
        puts json["project"]

        expect(json["project"]["api_id"]).to eq("prj_123")
      end
    end

    context "without a project at the id" do
      it "returns a 404"
    end
  end
end
