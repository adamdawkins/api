# typed: strict

module Orange
  class Agreement < T::Struct
    extend T::Sig
    include Struct

    const :id, Integer
    const :paid, T::Boolean
  end
end
