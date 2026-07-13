# typed: true
# frozen_string_literal: true

require_relative "../results"

module Results
  # Dry::Operation-style flow structure for Results.
  #
  #   class Decline
  #     include Results::Operation
  #
  #     def call(project)
  #       validated = step validate_status(project)
  #       declined  = validated.with(status: Project::Status::FinanceDecline)
  #
  #       [declined, [Cmd::Project::CancelPiiVisits.new(declined.id)]]
  #     end
  #   end
  #
  # `step` unwraps a Success in place; a Failure aborts #call immediately
  # and is returned to the caller as-is. When #call completes without a
  # failed step, its return value is wrapped in a Success — unless it
  # already returned a Result, which passes through untouched.
  module Operation
    extend T::Sig

    HALT = T.let(Object.new.freeze, Object)

    # Prepended so a failed step can abort #call, and so #call's raw
    # return value gets wrapped.
    module Wrapper
      extend T::Sig

      sig { params(args: T.untyped, kwargs: T.untyped, blk: T.untyped).returns(T.untyped) }
      def call(*args, **kwargs, &blk)
        returned = Kernel.catch(HALT) { super }

        case returned
        when Result then returned
        else Success.new(returned)
        end
      end
    end

    sig { params(base: Module).void }
    def self.included(base)
      base.prepend(Wrapper)
    end

    sig { params(result: Result[T.untyped, T.untyped]).returns(T.untyped) }
    def step(result)
      case result
      when Success then result.value!
      when Failure then Kernel.throw(HALT, result)
      else T.absurd(result)
      end
    end
  end
end
