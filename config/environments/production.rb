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
config.cache_store = :mem_cache_store, '10.6.64.128:11211', '10.6.64.129:11211', '10.6.64.130:11211', '10.6.64.131:11211', '10.6.64.132:11211', '10.6.64.133:11211', '10.6.64.134:11211', '10.6.64.135:11211', '10.6.64.136:11211', '10.6.64.137:11211', '10.6.64.138:11211'

config.gem 'hoptoad_notifier'
