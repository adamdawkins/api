# typed: strict

module Orange
  class Address < T::Struct
    extend T::Sig
    include Struct

    const :line1,   String
    const :city,    String
    const :state,   State
    const :zipcode, Zipcode


    sig { params(_options: T.untyped).returns(T::Hash[String, T.untyped]) }
    def as_json(*_options) = serialize
  end
end
