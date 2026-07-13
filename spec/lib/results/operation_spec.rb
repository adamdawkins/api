require "support/result_matchers"

require_relative "../../../lib/results/operation"

RSpec.describe Results::Operation do
  let(:operation_class) do
    Class.new do
      include Results::Operation

      def call(first_result, second_result)
        first = step first_result
        second = step second_result

        [ first, second ]
      end
    end
  end

  let(:success) { Results::Success.new("one") }
  let(:another_success) { Results::Success.new("two") }
  let(:failure) { Results::Failure.new(:nope) }

  describe "#step" do
    it "unwraps each Success in place" do
      result = operation_class.new.call(success, another_success)

      expect(result).to succeed_with([ "one", "two" ])
    end

    it "returns the Failure from #call as soon as a step fails" do
      result = operation_class.new.call(failure, another_success)

      expect(result).to fail_with(:nope)
    end

    it "does not run the steps after a failure" do
      spied = Class.new do
        include Results::Operation

        attr_reader :reached

        def call(first_result)
          step first_result
          @reached = true
        end
      end.new

      spied.call(failure)

      expect(spied.reached).to be_nil
    end

    it "rejects a non-Result" do
      bad = Class.new do
        include Results::Operation

        def call = step("not a result")
      end

      expect { bad.new.call }.to raise_error(TypeError)
    end
  end

  describe "#call wrapping" do
    it "wraps a raw return value in a Success" do
      raw = Class.new do
        include Results::Operation

        def call = "plain value"
      end

      expect(raw.new.call).to succeed_with("plain value")
    end

    it "passes an explicit Result through without double-wrapping" do
      explicit = Class.new do
        include Results::Operation

        def call = Results::Failure.new(:deliberate)
      end

      expect(explicit.new.call).to fail_with(:deliberate)
    end
  end
end
