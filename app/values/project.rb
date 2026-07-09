# typed: true

class Project < T::Struct
  extend T::Sig

  const :api_id, String
  const :office_key, String
  const :id, Integer

  def po = "#{office_key}-#{id}"

    private :id
end
