# typed: true

module Orange
  class FinanceProject < T::Struct
    extend T::Sig
    include StructEquality

    const :id, Integer
    const :status, Project::Status

    def as_json(*) = serialize
  end
end
