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
      case other
      when Success then T.unsafe(value) == other.value
      else false
      end
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
      case other
      when Failure then T.unsafe(value) == other.value
      else false
      end
    end

    sig { returns(String) }
    def to_s = "Failure(#{value})"
    alias inspect to_s

    protected

    sig { returns(ErrType) }
    attr_reader :value
  end

  # Typed constructor functions, dry-monads style:
  #
  #   include Results::Mixin
  #
  #   Success([project, cmds])   # : Results::Success[[Project, ...]]
  #   Failure(:wrong_status)     # : Results::Failure[Symbol]
  #
  # Prefer these over Success.new/Failure.new: sorbet does not infer a
  # class's type arguments from constructor arguments (Success.new(x) is
  # Success[T.anything], which satisfies no useful sig), but it does
  # infer a generic method's from its arguments.
  module Mixin
    extend T::Sig

    # rubocop:disable Naming/MethodName
    sig do
      type_parameters(:T)
        .params(value: T.type_parameter(:T))
        .returns(Success[T.type_parameter(:T)])
    end
    def Success(value)
      Success[T.type_parameter(:T)].new(value)
    end

    sig do
      type_parameters(:E)
        .params(value: T.type_parameter(:E))
        .returns(Failure[T.type_parameter(:E)])
    end
    def Failure(value)
      Failure[T.type_parameter(:E)].new(value)
    end
    # rubocop:enable Naming/MethodName
  end
end
