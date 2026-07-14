# typed: strict

module Orange
  class Project < T::Struct
    extend T::Sig
    include Struct

    const :api_id, String
    const :office_key, String
    const :id, Integer
    const :status, Status
    const :customer, T.nilable(Customer)

    sig { returns(String) }
    def po = "#{office_key}-#{id}"

      sig { params(_options: T.untyped).returns(T::Hash[String, T.untyped]) }
    def as_json(*_options) = serialize.merge("po" => po)
  end
end
