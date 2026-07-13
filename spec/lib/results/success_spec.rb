require "support/shared/result_examples"

require_relative "../../../lib/results"

RSpec.describe Results::Success do
  subject(:success) { described_class.new("foo") }

  it_behaves_like "a Result"

  it { is_expected.to be_success }
  it { is_expected.not_to be_failure }

  describe "equality" do
    # two Success classes with the same value are equal
    it { is_expected.to eq(described_class.new("foo")) }

    # A Failure with the same value is the not the same as a Success
    it { is_expected.not_to eq(Results::Failure.new("foo")) }
  end

  describe "#value_or" do
    it "returns the value" do
      expect(success.value_or("default")).to eq("foo")
    end
  end

  describe "#value!" do
    it "unwraps the value" do
      expect(success.value!).to eq("foo")
    end
  end

  describe "#to_s" do
    it "returns a string representation of the Success with the value" do
      expect(success.to_s).to eq("Success(foo)")
    end
  end

  describe "#inspect" do
    it "returns a string representation of the Success with the value" do
      expect(success.inspect).to eq("Success(foo)")
    end
  end
end
