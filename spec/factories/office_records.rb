FactoryBot.define do
  factory :office_record do
    sequence(:key) { |n| "OFC#{n}" }
    sequence(:name) { |n| "Office #{n}" }
  end
end
