# typed: strict

module Orange
  class PiiVisit < T::Struct
    extend T::Sig
    include Struct

    class Status < T::Enum
      enums do
        Pending   = new("pending")
        Cancelled = new("cancelled")
        NoDemo    = new("no_demo")
        Finished  = new("finished")
      end
    end

    const :appointment_at, T.nilable(DateTime)
    const :id,             Integer
    const :status,         Status
  end
end
