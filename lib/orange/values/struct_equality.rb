# typed: true

module Orange
  # T::Struct compares by identity, not value. Include this in a T::Struct
  # to get structural equality across all props, as recommended by the
  # Sorbet docs.
  module StructEquality
    extend T::Helpers

    requires_ancestor { T::Struct }

    def ==(other)
      other.class == self.class && other.serialize == serialize
    end
    alias_method :eql?, :==

    def hash = [ self.class, serialize ].hash
  end
end
