require "rails_helper"

RSpec.describe 'Projects API', type: :request do
  describe "GET /api/v1/projects/1.json" do
    subject(:req) { get "/api/v1/projects/1.json" }
    context "with a project at the id" do
    it "returns a 200" do
      req
      expect(response).to have_http_status(200)
    end

    it "returns the project"
    end

    context "without a project at the id" do
      it "returns a 404"
    end
  end
end
