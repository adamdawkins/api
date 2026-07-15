FactoryBot.define do
  factory :agreement_record do
    lender factory: :lender_record
  end
end
