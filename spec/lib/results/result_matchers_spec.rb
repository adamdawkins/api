# typed: ignore — exercises the RSpec::Matchers DSL, which has no RBIs
require "support/result_matchers"

require_relative "../../../lib/results"

RSpec.describe "Result matchers" do
  describe "succeed_with" do
    it "matches a Success containing the expected value" do
      expect(Results::Success.new("pong")).to succeed_with("pong")
    end

    it "does not match a Success containing a different value" do
      expect(Results::Success.new("pong")).not_to succeed_with("ping")
    end

    it "does not match a Failure" do
      expect(Results::Failure.new("pong")).not_to succeed_with("pong")
    end

    it "does not match a non-Result" do
      expect("pong").not_to succeed_with("pong")
    end

    it "accepts composable matchers" do
      expect(Results::Success.new("pong")).to succeed_with(an_instance_of(String))
    end

    it "describes the failure in Result notation" do
      expect {
        expect(Results::Failure.new(:nope)).to succeed_with("pong")
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                       'expected Success("pong"), got Failure(nope)')
    end
  end

  describe "fail_with" do
    it "matches a Failure containing the expected error" do
      expect(Results::Failure.new(:nope)).to fail_with(:nope)
    end

    it "does not match a Failure containing a different error" do
      expect(Results::Failure.new(:nope)).not_to fail_with(:wrong)
    end

    it "does not match a Success" do
      expect(Results::Success.new(:nope)).not_to fail_with(:nope)
    end

    it "does not match a non-Result" do
      expect(:nope).not_to fail_with(:nope)
    end

    it "accepts composable matchers" do
      expect(Results::Failure.new(:nope)).to fail_with(an_instance_of(Symbol))
    end

    it "describes the failure in Result notation" do
      expect {
        expect(Results::Success.new("pong")).to fail_with(:nope)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                       'expected Failure(:nope), got Success(pong)')
    end
  end
end
