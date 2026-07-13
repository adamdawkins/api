RSpec.shared_examples "a Result" do
  it { is_expected.to be_a(Results::Result) }

  it { is_expected.to respond_to(:success?) }
  it { is_expected.to respond_to(:failure?) }
  it { is_expected.to respond_to(:value!) }
  it { is_expected.to respond_to(:value_or) }
end
