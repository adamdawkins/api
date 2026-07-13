# typed: true

module Orange
  class Customer < T::Struct
    extend T::Sig
    include Struct

    const :first_name, String
    const :last_name, String
    const :address, T.nilable(Address)

    def as_json(*) = serialize
  end
end
