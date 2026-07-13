# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

# Success/Failure result values, in the style of Elm's `Result x a`.
#
# `Result` is a sealed interface, so everything that can be a result lives in
# this one file — that's what lets `case`/`when` over a result end with
# `T.absurd` and have `srb tc` prove every variant is handled.
module Results
  class UnwrapError < StandardError; end

  module Result
    extend T::Sig
    extend T::Helpers
    extend T::Generic

    interface!
    sealed!

    OkType = type_member(:out)
    ErrType = type_member(:out)

    sig { abstract.returns(T::Boolean) }
    def success?; end

    sig { abstract.returns(T::Boolean) }
    def failure?; end

    sig { abstract.returns(OkType) }
    def value!; end
  end

  class Success
    extend T::Sig
    extend T::Generic
    include Result

    OkType = type_member(:out)
    ErrType = type_member { { fixed: T.noreturn } }

    sig { params(value: OkType).void }
    def initialize(value)
      @value = value
    end

    sig { type_parameters(:U).params(_default: T.type_parameter(:U)).returns(OkType) }
    def value_or(_default) = value

    sig { override.returns(OkType) }
    def value!
      value
    end

    sig { override.returns(T::Boolean) }
    def success? = true

    sig { override.returns(T::Boolean) }
    def failure? = false

    sig { params(other: T.anything).returns(T::Boolean) }
    def ==(other)
      other.is_a?(Success) && value == other.value
    end

    sig { returns(String) }
    def to_s = "Success(#{value})"
    alias inspect to_s

    protected

    sig { returns(OkType) }
    attr_reader :value
  end

  class Failure
    extend T::Sig
    extend T::Generic
    include Result

    OkType = type_member { { fixed: T.noreturn } }
    ErrType = type_member(:out)

    sig { params(value: ErrType).void }
    def initialize(value)
      @value = value
    end

    sig { override.returns(T::Boolean) }
    def success? = false

    sig { override.returns(T::Boolean) }
    def failure? = true

    sig { type_parameters(:U).params(default: T.type_parameter(:U)).returns(T.type_parameter(:U)) }
    def value_or(default) = default

    sig { returns(ErrType) }
    def failure = value

    sig { override.returns(T.noreturn) }
    def value!
      raise UnwrapError, "#value! was called on #{self}"
    end

    sig { params(other: T.anything).returns(T::Boolean) }
    def ==(other)
      other.is_a?(Failure) && value == other.value
    end

    sig { returns(String) }
    def to_s = "Failure(#{value})"
    alias inspect to_s

    protected

    sig { returns(ErrType) }
    attr_reader :value
  end
end
