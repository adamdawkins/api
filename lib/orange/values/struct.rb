# typed: true

module Orange
  # The record-value bundle: include in a T::Struct to get value equality
  # and Data-style #with in one line.
  #
  #   class Project < T::Struct
  #     include Struct
  #     ...
  #   end
  #
  # A module rather than a base class because T::Struct forbids all
  # subclassing, and T::InexactStruct would forfeit sorbet's typed
  # initializers.
  #
  # Values come in three shapes here: records are T::Structs including
  # this, enums extend T::Enum, and constrained scalars are hand-rolled
  # (see Zipcode).
  module Struct
    extend T::Helpers

    requires_ancestor { T::Struct }

    include StructEquality
    include StructCopy
  end
end
