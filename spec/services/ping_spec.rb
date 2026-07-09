require "rails_helper"

RSpec.describe Ping do
  it "returns a Success result" do
    result = described_class.new.call

    expect(result).to be_success
    expect(result.value!).to eq("pong")
  end
end
