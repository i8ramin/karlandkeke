ruby '2.1.6'

source 'https://rubygems.org' do
  gem 'bundler', '>= 1.8.4'

  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '4.2.5'

  gem 'pg'
  gem 'puma'

  gem 'mongoid', '~> 5.0.0'

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
  gem 'omniauth', '~> 1.2'
  gem 'omniauth-auth0', '~> 1.1'

  # https://devcenter.heroku.com/articles/memcachier#rails-3-and-4
  gem 'dalli'
  gem 'memcachier'

  group :production, :staging do
    gem 'rails_12factor'
    gem 'rack-timeout'
  end

  group :development, :test do
    gem 'sqlite3'
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug'
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


source 'https://rails-assets.org' do
  # https://rails-assets.org/
  gem 'rails-assets-foundation-sites'
end
