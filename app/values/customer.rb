# typed: true

class Customer < T::Struct
  extend T::Sig
  include StructEquality

  const :first_name, String
  const :last_name, String
  const :address, T.nilable(Address)

  def as_json(*) = serialize
end
