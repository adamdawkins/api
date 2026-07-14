# typed: strict

module Orange
  class FinanceProject < T::Struct
    extend T::Sig
    include Struct

    const :id, Integer
    const :status, Project::Status


    sig { params(_options: T.untyped).returns(T::Hash[Symbol, T.untyped]) }
    def as_json(*_options) = serialize
  end
end
