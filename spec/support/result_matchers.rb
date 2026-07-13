# typed: ignore — RSpec::Matchers DSL has no RBIs
# RSpec matchers for Results values.
#
#   expect(result).to succeed_with(project)
#   expect(result).to fail_with(:project_in_wrong_status)
#
# Both accept composable matchers: `succeed_with(an_instance_of(Project))`.
RSpec::Matchers.define :succeed_with do |expected|
  match do |result|
    result.respond_to?(:success?) && result.success? &&
      values_match?(expected, result.value!)
  end

  description { "succeed with #{description_of(expected)}" }

  failure_message do |result|
    "expected Success(#{description_of(expected)}), got #{result.inspect}"
  end

  failure_message_when_negated do |result|
    "expected anything but Success(#{description_of(expected)}), got #{result.inspect}"
  end
end

RSpec::Matchers.define :fail_with do |expected|
  match do |result|
    result.respond_to?(:failure?) && result.failure? &&
      values_match?(expected, result.failure)
  end

  description { "fail with #{description_of(expected)}" }

  failure_message do |result|
    "expected Failure(#{description_of(expected)}), got #{result.inspect}"
  end

  failure_message_when_negated do |result|
    "expected anything but Failure(#{description_of(expected)}), got #{result.inspect}"
  end
end
