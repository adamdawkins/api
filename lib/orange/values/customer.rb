# typed: strict

module Orange
  class Customer < T::Struct
    extend T::Sig
    include Struct

    const :first_name, String
    const :last_name, String
    const :address, T.nilable(Address)


    sig { params(_options: T.untyped).returns(T::Hash[String, T.untyped]) }
    def as_json(*_options) = serialize
  end
end
