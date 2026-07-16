class OperationJob < ApplicationJob
  queue_as { arguments.last[:queue] }

  # rubocop:disable Lint/UnusedMethodArgument, Metrics/ParameterLists
  before_perform do |job|
    if (options = job.arguments.last[:retry_options])
      self.class.retry_on options[:exception_class], **options[:options]
    end
  end

  # - the :queue argument is used in `queue_as` above.
  def perform(*args, operation:, retry_options: nil, queue: :default, **kwargs)
    operation.call(*args, **kwargs)
  end
end
# rubocop:enable Lint/UnusedMethodArgument, Metrics/ParameterLists
