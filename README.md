# karlandkeke

## Scrape data from a816-healthpsi.nyc.gov
```
bundle exec rake mongo:scrape
```

This will create add json files for individual daycare centers as well as daycares.json (collection) in data/json folder

## Setup Mongodb, import data, download npm packages
```
bundle install
brew install mongodb
bundle exec rake mongo:import
npm install
```

## On Heroku
```
heroku run rake mongo:import -a karlandkeke
```


This will set up mongodb locally and import the scraped data (This will wipe mongo clean and re-import the entire dataset)

## Check if you've imported data correctly

```
rails console
Daycare.count #2300
```
