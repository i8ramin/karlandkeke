class Infraction

  include Mongoid::Document
  belongs_to :inspection

  field :violation_summary, type: String
  field :category, type: String
  field :code_subsection, type: String
  field :status, type: String

  def self.from_json(payload)
      i = Infraction.new
      i.violation_summary = payload["Violation Summary "]
      i.save
      return i
  end

end
