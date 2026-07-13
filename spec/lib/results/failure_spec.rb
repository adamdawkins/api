require "support/shared/result_examples"

require_relative "../../../lib/results"

RSpec.describe Results::Failure do
  subject(:failure) { described_class.new("foo") }

  it_behaves_like "a Result"

  it { is_expected.to be_failure }
  it { is_expected.not_to be_success }

  describe "equality" do
    # two Failure classes with the same value are equal
    it { is_expected.to eq(described_class.new("foo")) }

    # A Success with the same value is the not the same as a Failure
    it { is_expected.not_to eq(Results::Success.new("foo")) }
  end

  describe "#value_or" do
    it "returns the provided default" do
      expect(failure.value_or("default")).to eq("default")
    end
  end

  describe "#failure" do
    it "returns the failure" do
      expect(failure.failure).to eq("foo")
    end
  end

  describe "#value!" do
    it "raises a Results:UnwrapError" do
      expect { failure.value! }.to raise_error(Results::UnwrapError, "#value! was called on Failure(foo)")
    end
  end

  describe "#to_s" do
    it "returns a string representation of the Failure with the value" do
      expect(failure.to_s).to eq("Failure(foo)")
    end
  end

  describe "#inspect" do
    it "returns a string representation of the Failure with the value" do
      expect(failure.inspect).to eq("Failure(foo)")
    end
  end
end
