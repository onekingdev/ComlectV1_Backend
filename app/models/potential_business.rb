class PotentialBusiness < ActiveRecord::Base
  validates_uniqueness_of :crd_number
end
