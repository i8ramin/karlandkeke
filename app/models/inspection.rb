class Inspection < ActiveRecord::Base

  belongs_to :daycares
  has_many :infractions

end
