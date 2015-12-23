desc "import JSON data into Mongo"
task :import_json => :environment do

    puts "BEGIN import JSON --> Mongo"
    counter = 0

    # makes sense to clear out the existing data in our case
    Infraction.destroy_all
    Inspection.destroy_all
    Daycare.destroy_all 
    seed_file = "db/daycares.json"
    puts "LOADING from file #{seed_file}"   
    file = File.read(seed_file)
    venues = JSON.parse(file)
    puts venues.size
    venues.each do |daycare|
        d = Daycare.from_json(daycare)
        puts d.inspect
    end

    puts "#{counter} records imported"
    puts "END   import JSON --> Mongo"

end
