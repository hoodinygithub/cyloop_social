
# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Be sure to restart your server when you modify this file
# Top of config/environment.rb
if File.exists?("#{File.dirname(__FILE__)}/passenger_cluster.yml")                      
  ENV["SITE"] = YAML.load_file("#{File.dirname(__FILE__)}/passenger_cluster.yml")["SITE"]
end

# ENV["SITE"] = "MSN Latam" if ENV['RAILS_ENV'] =~ /development/

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['SITE'] ||= 'MSN Brazil' if ENV['RAILS_ENV'] =~ /production|staging|ec2_production/
ENV['SITE'] ||= 'Cyloop' if ENV['RAILS_ENV'] =~ /development/
ENV['RAILS_ASSET_ID'] = '' if ENV['RAILS_ENV'] =~ /development/

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a dat abase
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on.
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  
  #active_support loads this for you, rails dependency handling is completely fucked up
  config.gem "json"
  config.gem 'memcache-client', :lib => 'memcache'

  #now to the gems we do control
  config.gem "haml",                    :version => "2.2.20"
  config.gem "geoip",                   :version => '0.8.6', :lib => false
  config.gem "nokogiri",                :version => '1.4.1', :source => 'http://gemcutter.org'
  config.gem "rubyist-aasm",            :version => "2.1.1", :lib => "aasm", :source => 'http://gems.github.com'
  config.gem "newrelic_rpm",            :version => '2.12.0'
  config.gem 'htmlentities',            :version => "4.2.0"
  config.gem 'will_paginate',           :version => '2.3.11', :source => 'http://gemcutter.org'
  config.gem 'rufus-tokyo',             :version => '1.0.5'
  config.gem 'oauth',                   :version => '0.3.4'
  config.gem 'moomerman-twitter_oauth', :version => '0.2.1', :lib => 'twitter_oauth', :source => 'http://gems.github.com'
  config.gem 'httparty',                :version => '0.4.5'
  config.gem 'ar_mailer',               :version => '1.5.0', :lib => 'action_mailer/ar_mailer', :source => 'http://gemcutter.org'
  config.gem "block_helpers",           :source => "http://gemcutter.org"
  config.gem 'redis-namespace',         :lib => 'redis/namespace'
  config.gem 'resque', :version => '1.2.3'
    
  
  # config.gem "methodmissing-scrooge", :lib => 'scrooge', :source => 'http://gems.github.com'
  # Only load the plugins named here, in the order given. By default, all
  # plugins in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # observers
  config.active_record.observers = :block_observer, :following_observer

  # Add additional load paths for your own custom dirs

  config.load_paths += %W(
    #{RAILS_ROOT}/app/observers
    #{RAILS_ROOT}/app/middlewares
    #{RAILS_ROOT}/app/mailers
    #{RAILS_ROOT}/app/services
  )
  # config.load_paths += ["#{RAILS_ROOT}/vendor/cyqueue/app/jobs"]

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_cyloop_session',
    :secret      => '594277ca5ce59b371b451a4da2211838f92008860360e661ffc3b5fc4fcd53d957a48109811196d335aec8a0ea93d5d954cec6619a86694f4fc11515513dee31'
  }

  config.action_controller.session_store = :cookie_store

  config.after_initialize do
    require 'ruby_core_extensions' # Look here for Hash and String additions
    require 'iconv'
  end
end
