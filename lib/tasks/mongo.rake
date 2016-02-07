require_relative '../../data/scraper.rb'

def load_venues(venues)
    counter = 0
    fails = []

    venues.each do |daycare|
        begin
        d = Daycare.from_json(daycare)
        counter += 1
        rescue Exception => e
            fails << daycare
            puts "FAILED TO PARSE DAYCARE"
            puts e.backtrace
            puts daycare.inspect
        end
    end

    puts "#{counter} records imported"
    puts "#{fails.size} failed to import"

end

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

    nyc_seed_file = "data/json/daycares.json"
    puts "LOADING from file #{nyc_seed_file}"   
    file = File.read(nyc_seed_file)
    nyc_venues = JSON.parse(file)
    load_venues(nyc_venues) 

    # pause so we can see the results of city parsing
    sleep(3)

    state_seed_file = "data/json/nys_daycares.json"
    puts "LOADING from file #{state_seed_file}"   
    file = File.read(state_seed_file)
    state_venues = JSON.parse(file)
    load_venues(state_venues) 

    puts "END   import JSON --> Mongo"
  end

#===================
  desc "Scrape data and import into Mongo"
  task scrape_import: :environment do
    nyc_daycares = []
    begin
      nyc_daycares = scraper
    rescue Exception => e
      puts "scrape failed."
      puts e.to_s
    end

    puts "Import NYC JSON --> Mongo"
    
    puts "--NYC Start"
    nyc_venues = JSON.parse(nyc_daycares)
    load_venues(nyc_venues)
    puts "---NYC End" 

    # # pause so we can see the results of city parsing
    sleep(3)
    nys_daycares = '';
    begin
      nys_daycares = nys_scraper
    rescue Exception => e
      puts "nystate scrape failed"
    end 

    puts "Import NYS JSON --> Mongo"
    puts "--NYS Start"
    state_venues = JSON.parse(nyc_daycares)
    load_venues(state_venues)

    puts "END   import JSON --> Mongo"
  end



end