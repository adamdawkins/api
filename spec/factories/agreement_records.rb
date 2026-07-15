FactoryBot.define do
  factory :agreement_record do
    lender  factory: :lender_record
    project factory: :project_record
  end
end
