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
        counter += 1
        begin
        d = Daycare.from_json(daycare)
        rescue Exception => e
            fails << daycare
            puts "FAILED TO PARSE DAYCARE #{ counter }"
            puts e.backtrace
            puts "\n\n"
        end

    end

    # create geospatial indexes
    Daycare.create_indexes

    puts "#{counter} records imported"
    puts "#{fails.size} failed to import"
    puts "END   import JSON --> Mongo"
  end

  desc "index Daycare data for full text search"
  task index: :environment do
    Daycare.update_ngram_index
  end
end

# TODO: since the master branch of the mongoid_search gem fails to install
# on Heroku, copying over the index rake task from the repo so we can use it
namespace :mongoid_search do
  desc 'Goes through all documents with search enabled and indexes the keywords.'
  task :index => :environment do
    ::Rails.application.eager_load!
    if Mongoid::Search.classes.blank?
      Mongoid::Search::Log.log "No model to index keywords.\n"
    else
      Mongoid::Search.classes.each do |klass|
        Mongoid::Search::Log.silent = ENV['SILENT']
        Mongoid::Search::Log.log "\nIndexing documents for #{klass.name}:\n"
        klass.index_keywords!
      end
      Mongoid::Search::Log.log "\n\nDone.\n"
    end
  end
end
