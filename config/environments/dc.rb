# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
# config.cache_classes = true
# 
# # Use a different logger for distributed setups
# # config.logger = SyslogLogger.new
# 
# # Full error reports are disabled and caching is turned on
# config.action_controller.consider_all_requests_local = false
# config.action_controller.perform_caching             = true

# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false


config.action_mailer.smtp_settings = {
  :address => "smtp.mail.yahoo.com.br",
  :domain => ' smtp.mail.yahoo.com.br  ',
  :user_name => "hoodiny.development@yahoo.com.br",
  :password => "123789456",
  :port => 587,
  :authentication => :login,
  :perform_deliveries => true,
  :default_from => 'Cyloop <hoodiny.development@yahoo.com>',
  :enable_starttls_auto => true,
}

config.action_mailer.delivery_method = :smtp

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = true ### DO NOT TURN THIS TO TRUE

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

config.cache_store = :mem_cache_store, '127.0.0.1:11211'
ENV['SITE'] = 'MSN Canada EN'