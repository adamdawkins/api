# typed: strict

module Orange
  # T::Struct compares by identity, not value. Include this in a T::Struct
  # to get structural equality across all props, as recommended by the
  # Sorbet docs.
  module StructEquality
    extend T::Helpers
    extend T::Sig

    requires_ancestor { T::Struct }

    sig { params(other: Object).returns(T::Boolean) }
    def ==(other)
      other.is_a?(T::Struct) && other.class == self.class && other.serialize == serialize
    end
    alias_method :eql?, :==

    sig { returns(Integer) }
    def hash = [ self.class, serialize ].hash
  end
end
