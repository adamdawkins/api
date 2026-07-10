# typed: true

class Address < T::Struct
  extend T::Sig
  include StructEquality

  const :line1,   String
  const :city,    String
  const :state,   String
  const :zipcode, String

  def as_json(*) = serialize
end
