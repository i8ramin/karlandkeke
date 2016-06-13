# karlandkeke

## Local setup instructions

*make you sure have postgis installed*

1. Clone
2. ```bundle install```
3. ```rake db:create```
4. ```rake db:gis:setup```
5. ```rake data:scrape```
6. Check that everything ran.

```
rails console
Daycare.count #2300
```

6. ```rails -s```
7. enjoy