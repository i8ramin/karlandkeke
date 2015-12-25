require_relative '../../data/scraper.rb'

namespace :mongo do
  desc "Scrape data and generate JSON"
  task scrape: :environment do
  	begin
  		scraper
  	rescue Exception => e
  		puts "scrape failed."
  		puts e.to_s
  	end
  end

  desc "import JSON data into Mongo"
  task import: :environment do
  	puts "BEGIN import JSON --> Mongo"
    counter = 0
    fails = []

    # makes sense to clear out the existing data in our case
    Infraction.destroy_all
    Inspection.destroy_all
    Daycare.destroy_all 
    seed_file = "data/json/daycares.json"
    puts "LOADING from file #{seed_file}"   
    file = File.read(seed_file)
    venues = JSON.parse(file)
    puts venues.size
    venues.each do |daycare|
        begin
        d = Daycare.from_json(daycare)
        counter += 1
        rescue Exception => e
            fails << daycare
            puts "FAILED TO PARSE DAYCARE"
            puts e.to_s
            puts daycare.inspect
        end

    end

    puts "#{counter} records imported"
    puts "#{fails.size} failed to import"
    puts "END   import JSON --> Mongo"
  end

end
