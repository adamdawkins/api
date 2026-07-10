# typed: true

class Address < T::Struct
  extend T::Sig
  include StructEquality

  const :line1,   String
  const :city,    String
  const :state,   String
  const :zipcode, Zipcode

  def as_json(*) = serialize
end
