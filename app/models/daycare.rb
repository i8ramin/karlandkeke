class Daycare < ActiveRecord::Base
	has_many :inspections, dependent: :destroy
  
	def self.from_json(payload)
	    permit_number = payload["permitNumber"]
	    return nil if permit_number.nil?

	    d = Daycare.where(:permit_number => permit_number).first
	    # if the daycare already exists, persist but wipe inspection history
	    if d
	        d.inspections.each do |insp|
	            infractions = insp.infractions
	            infractions.destroy_all
	            insp.destroy
	        end        
	    else
	        d = Daycare.new
	    end

	    # set basic attributes of daycare
		d.type = payload["type"]
		d.center_name= payload["centerName"].rstrip
		d.permit_holder = payload["permitHolder"]
		d.address = payload["address"]
		d.borough = payload["borough"]
		d.zipcode = payload["zipCode"]
		d.phone = payload["phone"]
		d.permit_status = payload["permitStatus"]
		d.permit_number = payload["permitNumber"]
		d.permit_expiration_date = payload["permitExpirationDate"]
		d.age_range = payload["ageRange"]
		d.maximum_capacity = payload["maximumCapacity"]
		d.site_type = payload["siteType"]
		d.certified_to_administer_medication = payload["certifiedToAdministerMedication"]

        # set complex attributes 
		dlat = payload["latitude"] || 0.0,
		dlong = payload["longitude"] || 0.0
		d.lonlat = 'POINT (%s %s)' % [dlat, dlong]
		d.permalink  = d.center_name.downcase.gsub(" ", "-")
		d.permalink += "-" + d.id if Daycare.where(permalink: d.permalink).count > 0
		years_operating   = 0
		years_operating   = payload["yearsOperating"] unless payload["yearsOperating"].blank?
		d.years_operating = years_operating

        # set daycare inspections
		inspections = payload["pastInspections"] << payload["latestInspection"]
		if inspections.length >= 1
		  payload["pastInspections"].each do |inspectResult|
		    i = Inspection.from_json(inspectResult)
		    d.inspections << i
		    i.daycare = d
		    i.save
		  end
		end

		d.grade = d.get_grade
		d.save
		return d
	end

	def get_latest_inspection
		return self.inspections.last
	end

	def get_grade
		score = 0
		score += 1 if self.certified_to_administer_medication?
		score += 2 if self.has_inspections?
		last_inspection = self.get_latest_inspection
		if last_inspection && last_inspection.number_of_infractions > 0
		  last_inspection.infractions.each do |inf|
		    score -= inf.multiplier
		  end
		end

		# Grades are WIP (its naive at best for now)
		# score can get as high as 3
		# score can get as low as the number of infractions it has
		case score
		  when 2..3
		    'a'
		  when 0..1
		    'b'
		  when -2..-1
		    'c'
		  when -25..-3
		    'f'
		end
	end
end
