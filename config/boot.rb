ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

require 'rails/commands/server'
module Rails
  class Server
    def default_options
      if Rails.env.development?
        super.merge!(Port: (ENV['PORT'] || 1212))
      else
        super
      end
    end
  end
end
