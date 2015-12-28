class Infraction
  require 'csv'
  include Mongoid::Document
  belongs_to :inspection

  field :violation_summary, type: String
  field :category, type: String
  field :code_subsection, type: String
  field :status, type: String
  field :short_definition, type: String
  field :simple_summary, type: String
  field :extra_notes, type: String

  def self.from_json(payload)
      i = Infraction.new
      i.violation_summary = payload["Violation Summary "]
      i.category = payload["Category "]
      i.code_subsection = payload["Code Sub-Section"]
      simplified_code = @@simplified_codes[i.code_subsection.gsub(/[^0-9a-z\\s]/i, '')]
      if simplified_code.present?
        i.short_definition = simplified_code[:short_definition]
        i.simple_summary   = simplified_code[:one_word]
        i.extra_notes      = simplified_code[:extra]
      end
      
      i.status = payload[" Status"]
      i.save
      return i
  end
  
  @@simplified_codes = {}
  data = CSV.read("data/simplified_health_codes.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})
  data.map { |d| 
    d = d.to_hash
    simplified_code = d[:code].gsub(/[^0-9a-z ]/i, '')
    @@simplified_codes[simplified_code] = d 
  }

end
