# typed: true

class Zipcode
  extend T::Sig
  extend T::Props::CustomType

  sig { params(value: String).void }
  def initialize(value)
    @value = value.dup.freeze
    unless valid_zipcode?(@value)
      raise ArgumentError, "Zipcode must be a 5-digit string"
    end
  end

  sig { override.params(instance: Zipcode).returns(String) }
  def self.serialize(instance) = instance.to_s

  sig { override.params(scalar: String).returns(Zipcode) }
  def self.deserialize(scalar) = new(scalar)

  sig { returns(String) }
  def to_s
    @value.to_s
  end

  sig { params(other: T.untyped).returns(T::Boolean) }
  def ==(other)
    other.is_a?(Zipcode) && @value == other.to_s
  end
  alias_method :eql?, :==

  sig { returns(Integer) }
  def hash = [ self.class, @value ].hash

  private

  def valid_zipcode?(value)
    value.match?(/\A\d{5}\z/)
  end
end
