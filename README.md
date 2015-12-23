# karlandkeke

## Scrape data from a816-healthpsi.nyc.gov
```
ruby data/scraper.rb
```

This will create add json files for individual daycare centers as well as daycares.json (collection) in data/json folder

## Setup Mongodb, import data
```
bundle install
brew install mongodb
bundle exec rake import_json
```

This will set up mongodb locally and import the scraped data (This will wipe mongo clean and re-import the entire dataset)

## Check if you've imported data correctly

```
rails console
Daycare.count #2300
```