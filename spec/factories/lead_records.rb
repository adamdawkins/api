FactoryBot.define do
  factory :lead_record do
    sequence(:api_id) { |n| "lead_#{n}" }
  end
end
