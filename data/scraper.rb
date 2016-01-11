require 'rubygems'
require 'mechanize'
require 'csv'
require 'json'
require_relative 'pagescrape.rb'

def scraper
	daycares = []
	agent1 = Mechanize.new
	agent2 = Mechanize.new

	# output = File.new("output2.csv","w")
	# output.print("centerName,permitHolder,address,borough,phone,zipCode,permitNumber,permitExpirationDate,permitStatus,ageRange,maximumCapacity,certifiedToAdministerMedication,siteType")
	# output.print("\n")

	offset = 0
	offset_limit = 999999999

	# do initial pageview
	form_data = {
		linkPK:0,
		pageroffset:0,
		getNewResult:true,
		progTypeValues: '',
		search:1,
		facilityName: '',
		borough: '',
		permitNo: '',
		neighborhood: '',
		zipCode: ''
	}
	page = agent1.post 'https://a816-healthpsi.nyc.gov/ChildCare/SearchAction2.do'
	form = page.forms.first
	page = form.submit
	agent1.cookie_jar.save_as 'data/cookies', :session => true, :format => :yaml

	while offset < offset_limit do
		puts "Offset: " + offset.to_s
		page = agent1.post 'https://a816-healthpsi.nyc.gov/ChildCare/SearchAction2.do?pager.offset=' + offset.to_s, form_data

		if offset == 0
			puts "getting total pagecount"
			pageCountText = page.search('span.PageText')[2].text
			pageCount = pageCountText[/\d\d\d\d/].to_i - 10 # since 10 per page
			puts "got page count!", pageCount
			offset_limit = pageCount
		end

		links = page.search('tr.gradeX.odd a')
		file_i = offset
		links.each do |link|
			id = link.to_s()
			id = id.split('redirectHistory(')[1]
			id = id[0,10]
			id = id.scan(/"([^"]*)"/)
			# puts id

			agent2.cookie_jar = agent1.cookie_jar

			idString = 'linkPK=' + id[0][0].to_s
			# puts idString

			page2 = agent2.post 'https://a816-healthpsi.nyc.gov/ChildCare/WDetail.do', idString ,({'Content-Type' => 'application/x-www-form-urlencoded'})
			daycare = pagescrape(page2)
			page3 = agent2.get 'https://a816-healthpsi.nyc.gov/ChildCare/html5/mobilemap.jsp?type=streetview'
			map_page_body = page3.parser.css('body')[0]['onload']
			map_page_body.to_s.gsub(/'(\-?\d+(\.\d+)?)',\s*'(\-?\d+(\.\d+)?)'/) { |match|
				ll = match.gsub(/'/, '').split(', ')
				daycare["latitude"], daycare["longitude"] = ll[0].to_f, ll[1].to_f
				# puts "lat: #{daycare['latitude']} lon: #{daycare['longitude']}"
			}

			filename = file_i.to_s.rjust(2, "0")
			File.open("data/json/#{ filename }.json","w") do |f|
			  f.write(JSON.pretty_generate(daycare))
			end

			daycares.push(daycare)
			file_i += 1

		end

		offset = offset + 10

	end

	File.open("data/json/daycares.json", "w") do |f|
		f.write(JSON.pretty_generate(daycares))
	end
	return daycares
end
