# origin CSV to JSON code from 
# https://gist.github.com/enriclluelles/1423950

require 'csv'
require 'json'
require 'mechanize'

siteCrawler = Mechanize.new

puts "getting CSV..."
# csv_url = 'https://data.ny.gov/api/views/cb42-qumz/rows.csv'
# crawlPage = siteCrawler.get(csv_url)
# csv_file = crawlPage.body
csv_file = File.open("nys_childcare.csv", "r") { |file| file.read  }
puts "--got CSV"

puts "parsing CSV"
lines = CSV.new(csv_file).readlines
keys = lines.delete lines.first

daycare_ls = lines.map do |values|
	Hash[keys.zip(values)]
end
puts "--parsed CSV"

centerTypes = {
	'FDC' =>'Family Day Care',
	'GFDC' => 'Group-Family Day Care',
	'SACC' => 'School-Age Child Care (After-School)'
}

BOROUGHS = [
	'Brookyln',
	'Queens',
	'Manhattan',
	'Staten Island',
	'Bronx'
	]

puts "PARSE PT. 2..."

# daycares.each_with_index do |daycare, i|
daycares = []
i = 0
while i < 20
	daycare = daycare_ls[i]

	if BOROUGHS.include? daycare["County"]
		puts i
		# puts daycare
		daycare['type'] = centerTypes[daycare.delete('Program Type')]
		daycare['borough'] = daycare.delete('County')
		daycare['zipCode'] = daycare.delete("Zip Code")
		daycare['address'] = "#{daycare.delete('Street Number')} #{daycare.delete('Street Name')}"
		daycare['centerName'] = daycare.delete("Facility Name")
		daycare['permitHolder'] = daycare.delete("Provider Name")
		
		ageRange_start = daycare.delete("Capacity Description")
		if !ageRange_start.nil?
			daycare['ageRange'] = ageRange_start.split(", ")[1].gsub(/Ages | years/, '').gsub('to','-')
		end

		siteCrawler.get daycare['Program Profile']
		daycares << daycare
		i += 1
	end

end

File.open("json/nys_daycares.json", "w") do |f|
	f.write(JSON.pretty_generate(daycares))
end
