# typed: strict
# frozen_string_literal: true

# Spike exemplar for the service-object pattern: Sorbet-typed, returns a
# Results result. Replace with the first real service.
class Ping
  extend T::Sig

  sig { returns(Results::Result[String, Symbol]) }
  def call
    Results::Success.new("pong")
  end
end
