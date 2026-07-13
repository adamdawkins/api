# typed: true

module Orange
  # Base class for commands: effects the core asks the shell to perform,
  # returned alongside the model from a flow.
  #
  # Subclasses group by subject (e.g. Cmd::Project), so a handler can match
  # a whole family with `case cmd; in Cmd::Project then ...` or a specific
  # command with `in Cmd::Project::CancelPiiVisits(project_id)`.
  class Cmd
    extend T::Sig
    extend T::Helpers

    abstract!

    sig { params(values: T.untyped, fields: T.untyped).void }
    def initialize(*values, **fields)
      @values = values
      @fields = fields
    end

    sig { returns(T::Array[T.untyped]) }
    def deconstruct = @values

    sig { params(_keys: T.nilable(T::Array[Symbol])).returns(T::Hash[Symbol, T.untyped]) }
    def deconstruct_keys(_keys) = @fields

    sig { params(other: T.untyped).returns(T::Boolean) }
    def ==(other)
      other.class == self.class &&
        other.deconstruct == deconstruct &&
        other.deconstruct_keys(nil) == deconstruct_keys(nil)
    end
    alias_method :eql?, :==

    sig { returns(Integer) }
    def hash = [ self.class, @values, @fields ].hash
  end
end
