class ZipcodeRecord < ApplicationRecord
  self.table_name = "zipcodes"

  belongs_to :town, class_name: "TownRecord"

  validates :code, presence: true, uniqueness: true
end
