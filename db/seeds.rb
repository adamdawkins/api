# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

office = OfficeRecord.find_or_create_by!(key: "LDN", name: "London")
lead = LeadRecord.find_or_create_by!(api_id: "lead_e2e_1") { |l| l.office = office }
ProjectRecord.find_or_create_by!(api_id: "prj_e2e_1") do |project|
  project.lead = lead
  project.office = office
end
