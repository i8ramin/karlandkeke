ruby '2.2.3'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

source 'https://rubygems.org' do
  gem 'bundler', '>= 1.8.4'

  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '4.2.5'

  gem 'puma'

  gem 'mongoid', '~> 5.0.0'
  gem 'mongoid-geospatial'
  gem 'mongoid_search'

  gem 'therubyracer'

  gem 'font-awesome-rails'
  gem 'bootstrap', '~> 4.0.0.alpha3'
  # gem 'autoprefixer-rails', '~> 6.2.1'

  # https://github.com/slim-template/slim-rails
  gem 'slim-rails'

  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 5.0'

  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'

  # Use jquery as the JavaScript library
  gem 'jquery-rails'

  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  # gem 'turbolinks'

  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  # gem 'jbuilder', '~> 2.0'

  # https://github.com/intridea/hashie
  gem 'hashie'

  # https://auth0.com/docs/server-platforms/rails
  # gem 'omniauth', '~> 1.2'
  # gem 'omniauth-auth0', '~> 1.1'

  # https://devcenter.heroku.com/articles/memcachier#rails-3-and-4
  gem 'dalli'
  gem 'memcachier'

  # Scraper-related gems
  gem 'mechanize'

  # pagination
  # https://github.com/amatsuda/kaminari
  gem 'kaminari'
  gem 'mongoid-pagination'

  # https://github.com/sferik/rails_admin
  # gem 'rails_admin'

  # https://github.com/browserify-rails/browserify-rails
  gem 'browserify-rails'

  # https://github.com/imgix/imgix-rails
  gem 'imgix-rails'

  # https://github.com/michaeldv/awesome_print
  gem 'awesome_print'

  group :production, :staging do
    gem 'rails_12factor'
    gem 'rack-timeout'
  end

  group :development, :test do
    gem 'byebug'
    gem 'pry-byebug'
    gem 'dotenv-rails'
  end

  group :development do
    gem 'thin'
    gem 'quiet_assets'
    gem 'better_errors'

    # Access an IRB console on exception pages or by using <%= console %> in views
    gem 'web-console', '~> 2.0'

    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
  end
end
