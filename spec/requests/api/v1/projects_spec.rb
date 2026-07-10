require "rails_helper"

RSpec.describe 'Projects API', type: :request do
  describe "GET /api/v1/projects/:api_id" do
    subject(:req) { get "/api/v1/projects/prj_123" }
    context "with a matching project" do
      before do
        lead = create(:lead_record, first_name: "John", last_name: "Doe")
        create(:project_record, api_id: "prj_123", lead:)
      end

      it "returns a 200" do
        req

        expect(response).to have_http_status(200)
      end

      it "returns the project" do
        req

        json = JSON.parse(response.body)

        expect(json["project"]["api_id"]).to eq("prj_123")
      end

      it "returns the status in snake_case" do
        req

        json = JSON.parse(response.body)

        expect(json["project"]["status"]).to eq("draft")
      end

      it "returns the customer first name and last name" do
        req

        json = JSON.parse(response.body)

        expect(json["project"]["customer"]["first_name"]).to eq("John")
        expect(json["project"]["customer"]["last_name"]).to eq("Doe")
      end
    end

    context "without a project at the id" do
      it "returns a 404"
    end
  end
end
