# origin CSV to JSON code from 
# https://gist.github.com/enriclluelles/1423950

require 'csv'
require 'json'
require 'mechanize'
require_relative 'cleanup.rb'

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
	'Region Code',
	'Address Omitted',
	'Phone Number Omitted',
	'Additional Address',
	'Floor',
	'Apartment'
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
csv_file = File.open("nys_childcare.csv", "r") { |file| file.read  }
# csv_url = 'https://data.ny.gov/api/views/cb42-qumz/rows.csv'
# crawlPage = siteCrawler.get(csv_url)
# csv_file = crawlPage.body
puts "--got CSV"



puts "initial csv parse"
lines = CSV.new(csv_file).readlines
keys = lines.delete lines.first
daycare_ls = lines.map do |values|
	Hash[keys.zip(values)]
end
puts "--initial parse complete"

### helper functions here
def years_open(open_date)
    seconds_in_year = 365 * 24 * 60 * 60
    d  = Date.strptime(open_date, '%m/%d/%Y')
    return ((Time.now - d.to_time) / seconds_in_year).floor
end

def valid_date?(date_str)
    valid = false
    begin
        Date.strptime(date_str, '%m/%d/%Y')
        valid = true
    rescue Exception => e
        puts e.to_s
        puts "|" + date_str + "|"
    end
    return valid
end

### end helper functions


puts "PARSE PT. 2..."

daycares = []
all_violations = []
i = 0
while i < 500
	daycare = daycare_ls[i]
# above^ for demo'ing purposes, below*v for full scrape
# daycare_ls.each_with_index do |daycare, i|
	if i % 100 == 0 
		puts i
	end

	# get the page to scrape. if 500 error, skip it before messing with anything else
	site = nil
	daycare_valid_profile = true
	while site.nil? do
		begin
			site = siteCrawler.get daycare['Program Profile']
			# puts "SUCESS"
		rescue Exception => e
			if e.message.include? '500'
				puts "500 error"
				puts "index #{i}"
				site = true
				daycare_valid_profile = false
				i+=1
			else
				puts "error getting page. trying again"
				puts e.message
				puts "index #{i}" 
			end
		end
	end
	
	if daycare_valid_profile == true
		# get rid of some unnecessary fields. Might slow things down a bit
		DROPLIST.each do |drop|
			daycare.delete(drop)
		end

		# a bunch of renames / sometimes formatting changes
		daycare['type'] = centerTypes[daycare.delete('Program Type')]
		daycare['permitStatus'] = daycare.delete("Facility Status")
		daycare['permitNumber'] = daycare.delete("Facility ID")
		daycare['permitExpirationDate'] = daycare.delete("License Expiration Date")
		daycare['maximumCapacity'] = daycare.delete("Total Capacity")
		daycare['certifiedToAdministerMedication'] = "No"
	    open_date = daycare.delete("Facility Opened Date")
		daycare['yearsOperating'] = years_open(open_date)
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

		daycare['siteType'] = daycare.delete('type')

		profileTop = site.search('#programoverviewDivImg')[0].text
		if profileTop.include? "This facility is approved to administer medications."
			# puts "administers meds"
			daycare['certifiedToAdministerMedication'] = "Yes"
		end

		inspectionHistory = site.search('#compliancehistoryDivImg')[0]
		inspectionTables = inspectionHistory.search('table')
		inspectionTop = inspectionTables[0]
		inspectionBottom = inspectionTables[1]

		latest_inspection = {}
		latest_inspection['date'] = inspectionTop.search('td')[0].text.split(': ')[1]
		latest_inspection['result'] = inspectionTop.search('td')[1].text.split('violations:' )[1]
		latest_inspection['infractions'] = []
		latest_inspection['numInfractions'] = 0
		latest_date_split = latest_inspection['date'].split(" ")
		latest_date_split[0] = Date::MONTHNAMES.index(latest_date_split[0])
		latest_date = latest_date_split.join "/"

	    latest_date = latest_date.gsub(",","")
		daycare['hasInspections'] = valid_date?(latest_date)


		# if will evaluate false if table doesn't exist
		if inspectionBottom
			violations_table = inspectionBottom.search('tr')
			violations_table.delete violations_table.first # headers

			violations = []
			violations_table.each do |violation_node|
				violation = {}
				sections = violation_node.search('td')
				VIOLATION_HEADERS.each_with_index do |header, header_i|
					violation[header] = sections[header_i]
				end
				date_spl = violation["Date"].text.split(" ")
				date_spl[0] = Date::MONTHNAMES.index(date_spl[0])
				violation["Date"] = date_spl.join("/").gsub(",", "")
				if latest_date == violation["Date"]
					latest_inspection['infractions'] << violation
					latest_inspection['numInfractions'] += 1
				else
					#  violations << violation
				end
			end

			daycare['latestInspection'] = latest_inspection
	        # For schema parity, removing this from JSON export
			# daycare['violations'] = violations
			all_violations += violations
		end

		daycares << cleanup(daycare)
		i += 1
	else
		puts "skipping daycare. missing profile"
	end
end

File.open("json/nys_daycares.json", "w") do |f|
	f.write(JSON.pretty_generate(daycares))
end

File.open("nys_violations.csv", "w") do |f|
	all_violations.each do  |v|
		f.write v.values.join(",")+"\n"
	end
end


