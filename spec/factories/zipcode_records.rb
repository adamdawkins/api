FactoryBot.define do
  factory :zipcode_record do
    sequence(:code) { |n| "1234#{n}" }

    town factory: :town_record
  end
end
