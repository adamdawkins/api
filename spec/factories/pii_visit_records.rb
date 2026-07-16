FactoryBot.define do
  factory :pii_visit_record do
    status { "Pending" }
    appointment_at { Time.now }
    project factory: :project_record
  end
end
