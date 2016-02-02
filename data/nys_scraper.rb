# origin CSV to JSON code from 
# https://gist.github.com/enriclluelles/1423950

require 'csv'
require 'json'
require 'mechanize'
require_relative 'cleanup.rb'

DEMO = true

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

DROPLIST = [
	'School Age Capacity',
	'Phone Extension',
	'City',
	'Preschool Capacity',
	'Toddler Capacity',
	'School District Name',
	'State',
	'Facility ID',
	'Region Code',
	'Address Omitted',
	'Phone Number Omitted',
	'Additional Address',
	'Floor',
	'Apartment',
	'Total Capacity'
]

VIOLATION_HEADERS = [
	'Date',
	'Code Sub-Section',
	'Violation Summary',
	' Status '
]

siteCrawler = Mechanize.new

# CSV setup
csv_file = nil
puts "getting CSV..."
if DEMO
	csv_file = File.open("nys_childcare.csv", "r") { |file| file.read  }
else
	csv_url = 'https://data.ny.gov/api/views/cb42-qumz/rows.csv'
	crawlPage = siteCrawler.get(csv_url)
	csv_file = crawlPage.body
end
puts "--got CSV"



puts "initial csv parse"
lines = CSV.new(csv_file).readlines
keys = lines.delete lines.first
daycare_ls = lines.map do |values|
	Hash[keys.zip(values)]
end
puts "--initial parse complete"



puts "PARSE PT. 2..."

daycares = []
i = 0
while i < 20
	daycare = daycare_ls[i]
# above for demo'ing purposes, below for real scrape
# daycare_ls.each_with_index do |daycare, i|

	if BOROUGHS.include? daycare["County"]
		puts i
		# puts daycare
		DROPLIST.each do |drop|
			daycare.delete(drop)
		end

		# a bunch of renames / sometimes formatting changes
		daycare['type'] = centerTypes[daycare.delete('Program Type')]
		daycare['permitStatus'] = daycare.delete("Facility Status")
		daycare['permitExpirationDate'] = daycare.delete("License Expiration Date")
		daycare['borough'] = daycare.delete('County')
		daycare['zipCode'] = daycare.delete("Zip Code")
		daycare['address'] = "#{daycare.delete('Street Number')} #{daycare.delete('Street Name')}"
		daycare['centerName'] = daycare.delete("Facility Name")
		daycare['permitHolder'] = daycare.delete("Provider Name")
		daycare['latitude'] = daycare.delete("Latitude").to_i
		daycare['longitude'] = daycare.delete("Longitude").to_i
		daycare['phone'] = daycare.delete("Phone Number")
		ageRange_start = daycare.delete("Capacity Description")
		
		if !ageRange_start.nil?
			daycare['ageRange'] = ageRange_start.split(", ")[1].gsub(/Ages | years/, '').gsub('to','-')
		end

		# actual scraping
		site = siteCrawler.get daycare['Program Profile']
		inspectionHistory = site.search('#compliancehistoryDivImg')[0]
		inspectionTables = inspectionHistory.search('table')
		inspectionTop = inspectionTables[0]
		inspectionBottom = inspectionTables[1]

		latest_insp = {}
		latest_insp['date'] = inspectionTop.search('td')[0].text.split(': ')[1]
		latest_insp['result'] = inspectionTop.search('td')[1].text.split('violations:' )[1]
		daycare['latestInspection'] = latest_insp

		if inspectionBottom
			violations_table = inspectionBottom.search('tr')
			violations_table.delete violations_table.first # headers

			violations = []
			violations_table.each do |violation_node|
				violation = {}
				sections = violation_node.search('td')
				VIOLATION_HEADERS.each_with_index do |header, header_i|
					violation[header.downcase] = sections[header_i]
				end
				date_spl = violation["date"].text.split(" ")
				date_spl[0] = Date::MONTHNAMES.index(date_spl[0])
				violation["date"] = date_spl.join "/"
				violations << violation
			end

			daycare['violations'] = violations
		end



		daycares << cleanup(daycare)
		i += 1
	end

end

File.open("json/nys_daycares.json", "w") do |f|
	f.write(JSON.pretty_generate(daycares))
end
