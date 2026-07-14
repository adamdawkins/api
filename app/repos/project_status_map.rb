# typed: strict

module ProjectStatusMap
  extend self
  extend T::Sig

  ACRONYMS = %w[hoa qc].freeze

  sig { params(status: Orange::Project::Status).returns(String) }
  def status_to_db(status)
    status.serialize.split("_").map { |word|
      ACRONYMS.include?(word) ? word.upcase : word.capitalize
    }.join(" ")
  end

  sig { params(value: String).returns(Orange::Project::Status) }
  def status_from_db(value)
    Orange::Project::Status.deserialize(value.downcase.tr(" ", "_"))
  end
end
