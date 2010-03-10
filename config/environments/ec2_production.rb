# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.action_mailer.smtp_settings = {
  :domain => "cyloop.com",
  :address => "smtp",
  :port => 25,
  :perform_deliveries => true,
  :default_from => 'Cyloop <no-reply@cyloop.com>'
}
config.action_mailer.delivery_method = :activerecord

config.log_level = :debug
ActionController::Base.session = {
  :domain => ".cyloop.com"
}
config.middleware.use "SetCookieDomain", ".cyloop.com"
# if ENV['SITE'] == 'mexico' || ENV['SITE'] == 'MSN Mexico'
#   config.cache_store = :mem_cache_store, '10.3.65.230:11211', '10.3.65.229:11211', {:timeout => nil}
# elsif ENV['SITE'] == 'brazil' || ENV['SITE'] == 'MSN Brazil'
#   config.cache_store = :mem_cache_store, '10.3.65.217:11211', '10.3.65.218:11211', {:timeout => nil}
# elsif ENV['SITE'] == 'latam' || ENV['SITE'] == 'MSN Latam'
#   config.cache_store = :mem_cache_store, '10.3.65.233:11211', '10.3.65.234:11211', {:timeout => nil}
# elsif ENV['SITE'] == 'latino' || ENV['SITE'] == 'MSN US Latin'
#   config.cache_store = :mem_cache_store, '10.3.65.238:11211', '10.3.65.239:11211', {:timeout => nil}
# else
#   config.cache_store = :mem_cache_store, '127.0.0.1:11211', {:timeout => nil}
# end

# config.cache_store = :mem_cache_store, '10.3.65.230:11211', '10.3.65.229:11211', '10.3.65.217:11211', '10.3.65.218:11211', '10.3.65.233:11211', '10.3.65.234:11211', '10.3.65.238:11211', '10.3.65.239:11211', {:timeout => nil}
config.cache_store = :mem_cache_store, '127.0.0.1:11211'