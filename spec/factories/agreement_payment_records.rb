FactoryBot.define do
  factory :agreement_payment_record do
    amount { 9.99 }
    collected_date { Date.today }

    agreement factory: :agreement_record
  end
end
