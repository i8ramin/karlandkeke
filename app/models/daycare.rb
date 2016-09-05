class Daycare < ActiveRecord::Base
	has_many :inspections, dependent: :destroy
end
