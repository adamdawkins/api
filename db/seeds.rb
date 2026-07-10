# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

LeadRecord.destroy_all
ZipcodeRecord.destroy_all
TownRecord.destroy_all
OfficeRecord.destroy_all

town = TownRecord.create!(name: "Newark")
zipcode = ZipcodeRecord.create!(code: "07101", town:, state: "NJ")

office = OfficeRecord.find_or_create_by!(key: "NJC", name: "New Jersey Central")
lead = LeadRecord.find_or_create_by!(api_id: "lead_abc",
                                     office:,
                                     first_name: "John",
                                     last_name: "Doe",
                                     zipcode: "07101",
                                     street_address: "123 Main St",
                                    )
ProjectRecord.find_or_create_by!(api_id: "prj_abc", lead:, office:)
