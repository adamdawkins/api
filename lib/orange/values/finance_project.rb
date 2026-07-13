# typed: true

module Orange
  class FinanceProject < T::Struct
    extend T::Sig
    include Struct

    const :id, Integer
    const :status, Project::Status

    def as_json(*) = serialize
  end
end
