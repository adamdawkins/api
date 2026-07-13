require "support/result_matchers"

require_relative "../../../lib/results"

RSpec.describe Results::Mixin do
  include Results::Mixin

  describe "Success()" do
    it "builds a Success of the value" do
      expect(Success("pong")).to succeed_with("pong")
    end
  end

  describe "Failure()" do
    it "builds a Failure of the value" do
      expect(Failure(:nope)).to fail_with(:nope)
    end
  end
end
