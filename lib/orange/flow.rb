# typed: strict

module Orange
  # Dry::Operation-style base class for core flows, speaking Results.
  #
  #   class Decline < Flow
  #     sig do
  #       params(project: FinanceProject)
  #         .returns(Results::Result[[ FinanceProject, T::Array[Cmd] ], Symbol])
  #     end
  #     def call(project)
  #       flow do
  #         validated = step validate_status(project)
  #
  #         [ validated.with(status: Project::Status::FinanceDecline),
  #           [ Cmd::Project::CancelPiiVisits.new(validated.id) ] ]
  #       end
  #     end
  #   end
  #
  # `step` unwraps a Success in place; a Failure aborts the `flow` block
  # immediately and becomes its return value. When the block finishes
  # without a failed step, its value is wrapped in a Success — unless it
  # is already a Result, which passes through untouched.
  #
  # The `flow` block (rather than invisible wrapping of #call) is what
  # keeps sigs honest: the flow declares its full Result type on #call,
  # sorbet checks call sites against it, and sorbet-runtime validates the
  # returned Result at runtime.
  class Flow
    extend T::Sig
    extend T::Helpers
    include Results::Mixin

    abstract!

    HALT = T.let(Object.new.freeze, Object)

    sig { params(blk: T.proc.returns(T.untyped)).returns(T.untyped) }
    def flow(&blk)
      returned = Kernel.catch(HALT) { blk.call }

      case returned
      when Results::Result then returned
      else Results::Success.new(returned)
      end
    end

    sig { params(result: Results::Result[T.untyped, T.untyped]).returns(T.untyped) }
    def step(result)
      case result
      when Results::Success then result.value!
      when Results::Failure then Kernel.throw(HALT, result)
      else T.absurd(result)
      end
    end
  end
end
