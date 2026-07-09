FactoryBot.define do
  factory :project_record do
    sequence(:api_id) { |n| "prj_#{n}" }
    lead factory: :lead_record
    office factory: :office_record
  end
end
