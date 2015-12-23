class Daycare

  include Mongoid::Document
  has_one :inspection

  field :type, type: String
  field :center_name, type: String
  field :permit_holder, type: String
  field :address, type: String
  field :borough, type: String
  field :zipCode, type: String
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

  def self.from_json(payload)
    d = Daycare.new
    d.type = payload["type"]
    d.center_name= payload["centerName"]
    i = Inspection.from_json(payload["latestInspection"])
    d.inspection = i
    i.daycare = d
    d.save
    i.save
    return d
  end

end
