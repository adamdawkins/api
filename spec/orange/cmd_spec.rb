require "orange_helper"

RSpec.describe Orange::Cmd do
  subject(:cmd) { TestCmd.new(**attributes) }

  before { stub_const("TestCmd", Class.new(described_class)) }

  let(:attributes) { { project_id: 42 } }
  let(:different_attributes) { { project_id: 43 } }

  it "is abstract" do
    expect { described_class.new }.to raise_error(RuntimeError, /abstract/)
  end

  describe "equality" do
    describe "#==" do
      context "with another Cmd of the same class with the same attributes" do
        let(:other) { TestCmd.new(**attributes) }

        it "returns true" do
          expect(cmd).to eq(other)
        end
      end

      context "with another Cmd of the same class with different attributes" do
        let(:other) { TestCmd.new(**different_attributes) }

        it "returns false" do
          expect(cmd).not_to eq(other)
        end
      end

      context "with a Cmd of a different class with the same attributes" do
        let(:other) { Class.new(Orange::Cmd).new(**attributes) }

        it "returns false" do
          expect(cmd).not_to eq(other)
        end
      end
    end

    describe "#eql?" do
      context "with another Cmd of the same class with the same attributes" do
        let(:other) { TestCmd.new(**attributes) }

        it "returns true" do
          expect(cmd).to eql(other)
        end
      end

      context "with another Cmd of the same class with different attributes" do
        let(:other) { TestCmd.new(**different_attributes) }

        it "returns false" do
          expect(cmd).not_to eql(other)
        end
      end

      context "with a Cmd of a different class with the same attributes" do
        let(:other) { Class.new(Orange::Cmd).new(**attributes) }

        it "returns false" do
          expect(cmd).not_to eql(other)
        end
      end
    end

    describe "#hash equality" do
      context "with another Cmd of the same class with the same attributes" do
        let(:other) { TestCmd.new(**attributes) }

        it "returns true" do
          expect(cmd.hash).to eq(other.hash)
        end
      end

      context "with another Cmd of the same class with different attributes" do
        let(:other) { TestCmd.new(**different_attributes) }

        it "returns false" do
          expect(cmd.hash).not_to eq(other.hash)
        end
      end
    end
  end

  describe "pattern matching" do
    it "deconstructs its attributes by key" do
      expect(cmd.deconstruct_keys(nil)).to eq(attributes)
    end
  end

  describe "positional payloads" do
    subject(:cmd) { TestCmd.new(42) }

    it "deconstructs positionally" do
      expect(cmd.deconstruct).to eq([ 42 ])
    end

    it "pattern matches with the payload" do
      expect((cmd in TestCmd[ 42 ])).to be true
    end
  end
end
