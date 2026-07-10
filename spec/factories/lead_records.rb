FactoryBot.define do
  factory :lead_record do
    sequence(:api_id) { |n| "lead_#{n}" }
    first_name { "John" }
    last_name { "Doe" }
  end
end
