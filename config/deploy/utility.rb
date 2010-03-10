set :application_url, "ec2_sinatra1"

role :app, application_url
role :web, application_url
role :db,  application_url, :primary => true

set :market_config_needed, false
