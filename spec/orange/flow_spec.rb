require "orange_helper"
require "support/result_matchers"

RSpec.describe Orange::Flow do
  let(:flow_class) do
    Class.new do
      include Orange::Flow

      def call(first_result, second_result)
        flow do
          first = step first_result
          second = step second_result

          [ first, second ]
        end
      end
    end
  end

  let(:success) { Results::Success.new("one") }
  let(:another_success) { Results::Success.new("two") }
  let(:failure) { Results::Failure.new(:nope) }

  describe "#step" do
    it "unwraps each Success in place" do
      result = flow_class.new.call(success, another_success)

      expect(result).to succeed_with([ "one", "two" ])
    end

    it "returns the Failure from the flow as soon as a step fails" do
      result = flow_class.new.call(failure, another_success)

      expect(result).to fail_with(:nope)
    end

    it "does not run the steps after a failure" do
      spied = Class.new do
        include Orange::Flow

        attr_reader :reached

        def call(first_result)
          flow do
            step first_result
            @reached = true
          end
        end
      end.new

      spied.call(failure)

      expect(spied.reached).to be_nil
    end

    it "rejects a non-Result" do
      bad = Class.new do
        include Orange::Flow

        def call = flow { step("not a result") }
      end

      expect { bad.new.call }.to raise_error(TypeError)
    end
  end

  describe "#flow wrapping" do
    it "wraps the block's value in a Success" do
      raw = Class.new do
        include Orange::Flow

        def call = flow { "plain value" }
      end

      expect(raw.new.call).to succeed_with("plain value")
    end

    it "passes an explicit Result through without double-wrapping" do
      explicit = Class.new do
        include Orange::Flow

        def call = flow { Results::Failure.new(:deliberate) }
      end

      expect(explicit.new.call).to fail_with(:deliberate)
    end
  end
end
