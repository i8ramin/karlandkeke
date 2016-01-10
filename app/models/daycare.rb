class Daycare
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Pagination
  include Mongoid::FullTextSearch
  include Mongoid::Geospatial

  has_one :inspection

  field :type, type: String
  field :center_name, type: String
  field :permalink, type: String
  field :permit_holder, type: String
  field :location,  type: Point, spatial: true, delegate: true

  field :address, type: String
  field :borough, type: String
  field :zipcode, type: String
  field :phone, type: String
  field :permit_status, type: String
  # should permit number be an int, does it matter?
  field :permit_number, type: String
  field :permit_expiration_date, type: String
  field :age_range, type: String
  field :maximum_capacity, type: Integer
  field :site_type, type: String
  field :certified_to_administer_medication, type: Boolean
  field :years_operating, type: Integer
  field :has_inspections, type: Boolean
  field :grade, type: String

  # query by location
  spatial_scope :location

  fulltext_search_in :center_name, :zipcode

  def name; center_name end

  def self.from_json(payload)
    d = Daycare.new
    d.type = payload["type"]
    d.center_name= payload["centerName"].rstrip
    d.permit_holder = payload["permitHolder"]
    d.location = {
      latitude:  payload["latitude"] || 0.0,
      longitude: payload["longitude"] || 0.0
    }
    d.address = payload["address"]
    d.borough = payload["borough"]
    d.zipcode = payload["zipCode"]
    
    d.permalink  = d.center_name.downcase.gsub(" ", "-")
    d.permalink += "-" + d.id if Daycare.where(permalink: d.permalink).count > 0

    d.phone = payload["phone"]
    d.permit_status = payload["permitStatus"]
    d.permit_number = payload["permitNumber"]
    d.permit_expiration_date = payload["permitExpirationDate"]
    d.age_range = payload["ageRange"]
    d.maximum_capacity = payload["maximumCapacity"]
    d.site_type = payload["siteType"]
    d.certified_to_administer_medication = payload["certifiedToAdministerMedication"]
    years_operating   = 0
    years_operating   = payload["yearsOperating"] unless payload["yearsOperating"].blank?
    d.years_operating = years_operating
    d.has_inspections = payload["hasInspections"]

    i = Inspection.from_json(payload["latestInspection"])
    d.inspection = i
    d.grade = d.get_grade
    i.daycare = d
    d.save
    i.save
    return d
  end

  def get_grade
    score = 0
    score += 1 if self.certified_to_administer_medication?
    score += 2 if self.has_inspections?
    if self.inspection && self.inspection.number_of_infractions > 0
      self.inspection.infractions.each do |inf|
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
      when -10..-3
        'd'
      when -25..-10
        'e'
    end
  end
end
