# Shared examples for Cmd value equality and pattern matching.
#
# The host spec must define:
#   attributes           - the keyword arguments the cmd is built with
#   different_attributes - keyword arguments that build a non-equal cmd
RSpec.shared_examples "a Cmd" do
  subject(:cmd) { described_class.new(**attributes) }

  describe "equality" do
    describe "#==" do
      context "with another Cmd of the same class with the same attributes" do
        let(:other) { described_class.new(**attributes) }

        it "returns true" do
          expect(cmd).to eq(other)
        end
      end

      context "with another Cmd of the same class with different attributes" do
        let(:other) { described_class.new(**different_attributes) }

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
        let(:other) { described_class.new(**attributes) }

        it "returns true" do
          expect(cmd).to eql(other)
        end
      end

      context "with another Cmd of the same class with different attributes" do
        let(:other) { described_class.new(**different_attributes) }

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
        let(:other) { described_class.new(**attributes) }

        it "returns true" do
          expect(cmd.hash).to eq(other.hash)
        end
      end

      context "with another Cmd of the same class with different attributes" do
        let(:other) { described_class.new(**different_attributes) }

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
end
