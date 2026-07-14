# typed: strict

module Orange
  # Copy-with-changes for T::Structs, matching the stdlib's Data#with:
  #
  #   project.with(status: Project::Status::FinanceDecline)
  #
  # Builds through .new, so T::Struct's construction-time type validation
  # applies to the changes.
  module StructCopy
    extend T::Sig
    extend T::Helpers

    requires_ancestor { T::Struct }

    sig { params(changes: T.untyped).returns(T.self_type) }
    def with(**changes)
      klass = T.unsafe(self.class)

      klass.new(**klass.props.keys.to_h { |k| [ k, send(k) ] }, **changes)
    end
  end
end
