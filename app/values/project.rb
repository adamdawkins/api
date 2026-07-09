# typed: true

class Project < T::Struct
  extend T::Sig
  include StructEquality

  const :api_id, String
  const :office_key, String
  const :id, Integer

  def po = "#{office_key}-#{id}"

  def as_json(*) = serialize.merge("po" => po)
end
