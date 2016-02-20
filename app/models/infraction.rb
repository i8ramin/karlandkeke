class Infraction
  require 'csv'
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :inspection

  field :violation_summary, type: String
  field :category, type: String
  field :oneword_category, type: String
  field :code_subsection, type: String
  field :status, type: String
  field :short_description, type: String
  field :multiplier, type: Integer
  field :extra_notes, type: String

  MINOR    = " Minor violations General Violations "
  MAJOR    = " Violations requiring correction within two weeks Critical Violations "
  SEVERE   = " Violations requiring immediate correction Public Health Hazards "
  

  def self.from_json(payload)
      i = Infraction.new
      i.violation_summary = payload["Violation Summary"]
      case payload["Category "]
      when MINOR 
        i.oneword_category = 'minor'
        i.multiplier = 1
      when MAJOR
        i.oneword_category = 'major'
        i.multiplier = 2
      when SEVERE
        i.oneword_category = 'severe'
        i.multiplier = 3
      end
      i.code_subsection = payload["Code Sub-Section"]
      simplified_code = @@simplified_codes[i.code_subsection.gsub(/[^0-9a-z\\s]/i, '')]
      if simplified_code.present?
        i.short_description = simplified_code[:short_description]
        i.category          = simplified_code[:category]
        # Commenting the following line so we can be 
        # in tune with the way the city would grade
        # by using the category on the gov website
        i.multiplier        = simplified_code[:multiplier] unless i.multiplier
        i.extra_notes       = simplified_code[:extra]
      end

      i.multiplier = 1 if i.multiplier == 0 || i.multiplier.nil?
      i.status = payload["Status"]
      i.save
      return i
  end

  @@simplified_codes = {}
  data = CSV.read("data/simplified_health_codes.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})
  data.map { |d|
    d = d.to_hash
    simplified_code  = d[:code].gsub(/[^0-9a-z\\s]/i, '')
    reformatted_code = ""
    reformatted_code = d[:code_reformatted].to_s.gsub(/[^0-9a-z\\s]/i, '') unless d[:code_reformatted].nil?
    simplified_code  = reformatted_code if reformatted_code.length > simplified_code.length

    @@simplified_codes[simplified_code] = d
  }

end
