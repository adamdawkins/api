require "orange_helper"

RSpec.describe Orange::Cmd do
  it "is abstract" do
    expect { described_class.new }.to raise_error(RuntimeError, /abstract/)
  end
end
