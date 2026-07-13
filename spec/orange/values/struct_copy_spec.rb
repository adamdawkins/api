require "orange_helper"

RSpec.describe Orange::StructCopy do
  describe "#with" do
    subject(:project) do
      Orange::Project.new(api_id: "prj_1", office_key: "LDN", id: 1,
                          status: Orange::Project::Status::FinanceApproval)
    end

    it "returns a copy with the change applied" do
      declined = project.with(status: Orange::Project::Status::FinanceDecline)

      expect(declined.status).to eq(Orange::Project::Status::FinanceDecline)
    end

    it "keeps every other field" do
      declined = project.with(status: Orange::Project::Status::FinanceDecline)

      expect(declined.api_id).to eq("prj_1")
      expect(declined.office_key).to eq("LDN")
      expect(declined.id).to eq(1)
    end

    it "does not mutate the original" do
      project.with(status: Orange::Project::Status::FinanceDecline)

      expect(project.status).to eq(Orange::Project::Status::FinanceApproval)
    end

    it "returns an instance of the same class" do
      expect(project.with(id: 2)).to be_an(Orange::Project)
    end

    it "type-checks the changes" do
      expect { project.with(status: "nope") }.to raise_error(TypeError)
    end
  end
end
