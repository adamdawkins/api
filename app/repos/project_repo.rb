# typed: true

class ProjectRepo
  class << self
    extend T::Sig
    include ProjectStatusMap

    sig { params(api_id: String).returns(Orange::Project) }
    def by_api_id(api_id)
      record = ProjectRecord
        .joins(:office, lead: { zipcode_record: :town })
        .select(:id, :api_id, :status,
                offices: { key: :office_key },
                leads: [ :first_name, :last_name, :street_address ],
                town: { name: :city },
                zipcodes: { code: :zipcode, state: :state }
               ).find_by!(api_id:)

      Orange::Project.new(api_id: record.api_id,
                  office_key: record.office_key,
                  id: record.id,
                  status: status_from_db(record.status),
                  customer: customer(record)
                 )
    end

    private

    def customer(record)
      address = Orange::Address.new(line1: record.street_address,
                                    city: record.city,
                                    state: Orange::Address::State.deserialize(record.state),
                                    zipcode: Orange::Zipcode.new(record.zipcode))
      Orange::Customer.new(first_name: record.first_name,
                           last_name: record.last_name,
                           address:)
    end
  end
end
