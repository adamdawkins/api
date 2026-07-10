FactoryBot.define do
  factory :town_record do
    sequence(:name) { |n| "Town #{n}" }
  end
end
