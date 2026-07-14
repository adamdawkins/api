# typed: strict

module Orange
  class AccountingProject < T::Struct
    extend T::Sig
    include Struct

    const :id,                          Integer
    const :related_project_id,          T.nilable(Integer)

    const :collect_funds_independently, T::Boolean
    const :qc,                          T::Boolean
    const :status,                      Project::Status

    const :agreements,                  T::Array[Agreement]
    const :related_agreements,          T::Array[Agreement]


  sig { params(_options: T.untyped).returns(T::Hash[String, T.untyped]) }
  def as_json(*_options) = serialize
  end
end
