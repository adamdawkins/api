require "orange_helper"
require "support/shared/cmd_examples"

RSpec.describe Orange::Cmd::Project::CancelPiiVisits do
  it_behaves_like "a Cmd" do
    let(:attributes) { { project_id: 42 } }
    let(:different_attributes) { { project_id: 43 } }
  end

  describe "positional payloads" do
    subject(:cmd) { described_class.new(42) }

    it "deconstructs positionally" do
      expect(cmd.deconstruct).to eq([ 42 ])
    end

    it "pattern matches with the payload" do
      expect((cmd in Orange::Cmd::Project::CancelPiiVisits[ 42 ])).to be true
    end
  end

  describe "family matching" do
    subject(:cmd) { described_class.new(42) }

    it "matches Cmd::Project" do
      expect((cmd in Orange::Cmd::Project)).to be true
    end

    it "matches Cmd" do
      expect((cmd in Orange::Cmd)).to be true
    end
  end
end
