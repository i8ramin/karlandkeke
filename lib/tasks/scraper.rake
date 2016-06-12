require_relative '../../data/scraper.rb'
require_relative '../../data/nys_scraper.rb'

def load_venues(venues)
    counter = 0
    fails = []

    venues.each do |daycare|
        begin
        Daycare.from_json(daycare)
        puts "DAYCARE PARSED SUCCESSFULLY"
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

namespace :scraper do

  desc "Scrape data and import into application"
  task run: :environment do
    nys_daycares = '';
    begin
      nys_daycares = nys_scraper
      puts nys_daycares
    rescue Exception => e
      puts "nystate scrape failed"
    end

    puts "Import NYS JSON --> Mongo"
    puts "--NYS Start"
    state_venues = JSON.parse(nys_daycares)
    load_venues(state_venues)
    puts "END   import JSON --> Mongo"

    # # pause so we can see the results of city parsing
    sleep(3)
    nyc_daycares = ''
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

  end