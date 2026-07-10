require "sorbet-runtime"

require_relative "../../app/values/zipcode"

RSpec.describe Zipcode do
  subject (:zipcode) { described_class.new(code) }

  let(:code) { "12345" }

  context "with a valid zipcode (exactly 5-digit string)" do
    let(:code) { "12345" }

    it "does not raise an exception" do
      expect { zipcode }.not_to raise_error
    end

    describe "#to_s" do
      it "returns the value as a string" do
        expect(zipcode.to_s).to eq(code)
      end
    end

    describe "equality" do
      describe "#==" do
        context "with another Zipcode with the same value" do
        let(:other) { described_class.new(code) }

          it "returns true" do
            expect(zipcode).to eq(other)
          end
        end

        context "with another Zipcode with a different value" do
          let(:other) { described_class.new("67890") }

          it "returns false" do
            expect(zipcode).not_to eq(other)
          end
        end

        context "with another class of object with the same value" do
          let(:other) { "12345" }

          it "returns false" do
            expect(zipcode).not_to eq(other)
          end
        end
      end

      describe "#eql?" do
        context "with another Zipcode with the same value" do
          let(:other) { described_class.new(code) }

          it "returns true" do
            expect(zipcode).to eql(other)
          end
        end

        context "with another Zipcode with a different value" do
          let(:other) { described_class.new("67890") }

          it "returns false" do
            expect(zipcode).not_to eql(other)
          end
        end

        context "with another class of object with the same value" do
          let(:other) { "12345" }

          it "returns false" do
            expect(zipcode).not_to eql("12345")
          end
        end
      end

      describe "#hash equality" do
        context "with another Zipcode with the same value" do
          let(:other) { described_class.new(code) }
          it "returns true" do
            expect(zipcode.hash).to eq(other.hash)
          end
        end

        context "with another Zipcode with a different value" do
          let(:other) { described_class.new("67890") }

          it "returns false" do
            expect(zipcode.hash).not_to eq(other.hash)
          end
        end
      end
    end
  end

  context "without a string argument" do
    it "raises a TypeError" do
      expect { described_class.new(12345) }.to raise_error(TypeError)
    end
  end

  context "with a shorter string" do
    let(:code) { "1234" }

    it "raises an ArgumentError" do
      expect { zipcode }.to raise_error(ArgumentError)
    end
  end
  context "with a longer string" do
    let(:code) { "123456" }

    it "raises an ArgumentError" do
      expect { zipcode }.to raise_error(ArgumentError)
    end
  end

  context "with a non-numeric string" do
    let(:code) { "abcde" }

    it "raises an ArgumentError" do
      expect { zipcode }.to raise_error(ArgumentError)
    end
  end

  context "with a multiline string containing a valid line" do
    let(:code) { "12345\n678" }

    it "raises an ArgumentError" do
      expect { zipcode }.to raise_error(ArgumentError)
    end
  end

  describe "immutability" do
    it "is unaffected by later mutation of the input string" do
      code = "12345".dup
      zip  = described_class.new(code)

      code << "678"

      expect(zip.to_s).to eq("12345")
    end

    it "does not allow mutation through to_s" do
      expect { zipcode.to_s << "!" }.to raise_error(FrozenError)
    end
  end

  describe "serialization" do
    describe ".serialize" do
      it "returns the string representation of the zipcode" do
        expect(described_class.serialize(zipcode)).to eq("12345")
      end
    end

    context "as part of T::Struct" do
      let(:struct_class) { Class.new(T::Struct) { const :zipcode, Zipcode } }
      let(:struct) { struct_class.new(zipcode:) }

      it "serializes to a flat string" do
        expect(struct.serialize).to eq({ "zipcode" => "12345" })
      end

      it "deserializes from a flat string" do
        result = struct_class.from_hash({ "zipcode" => "12345" }).zipcode

        expect(result).to eq(zipcode)
      end
    end
  end
end
