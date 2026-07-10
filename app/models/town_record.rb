class TownRecord < ApplicationRecord
  self.table_name = "towns"

  validates :name, presence: true, uniqueness: true
end
