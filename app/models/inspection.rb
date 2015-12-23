class Inspection

  include Mongoid::Document

  belongs_to :daycare
  has_many :infractions

  field :date, type: DateTime
  field :result, type: String
  field :number_of_infractions, type: Integer

  def self.from_json(payload)
     i = Inspection.new
     i.date = payload["date"]
     i.result= payload["result"]
     i.number_of_infractions = payload["numInfractions"]
     i.save
     if payload["infractions"]
         payload["infractions"].each do |inf|
             infraction = Infraction.from_json(inf)
             infraction.inspection = i
             i.infractions << infraction
         end
     end
     i.save 
     return i
  end

end