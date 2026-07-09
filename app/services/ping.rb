# typed: strict
# frozen_string_literal: true

# Spike exemplar for the service-object pattern: Sorbet-typed, returns a
# Dry::Monads Result. Replace with the first real service.
class Ping
  extend T::Sig
  include Dry::Monads::Result::Mixin

  sig { returns(Dry::Monads::Result) }
  def call
    Success("pong")
  end
end
