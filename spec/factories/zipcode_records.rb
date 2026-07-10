FactoryBot.define do
  factory :zipcode_record do
    sequence(:code) { |n| "1234#{n}" }
    state { "NJ" }

    town factory: :town_record
  end
end
