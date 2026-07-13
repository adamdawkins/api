# typed: true

module Orange
  class Project < T::Struct
    extend T::Sig
    include Struct

    const :api_id, String
    const :office_key, String
    const :id, Integer
    const :status, Status
    const :customer, T.nilable(Customer)

    def po = "#{office_key}-#{id}"

    def as_json(*) = serialize.merge("po" => po)
  end
end
