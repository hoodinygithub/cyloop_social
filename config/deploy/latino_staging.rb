set :application_url, "ec2-174-129-84-214.compute-1.amazonaws.com"

role :app, application_url
role :web, application_url
role :db,  application_url, :primary => true

set :market_config_needed, true

# This will be substituted into nginx.conf for the environment
# wherever MARKET_ABBREV appears
set :market_abbrev, 'es'

# This will be substituted into nginx.conf wherever MARKET_NAME
# appears.
set :market_name, "uslatino"
set :site, "MSN US Latin"
set :nginx_listen, "80 default"
set :nginx_server_name, "latino.staging.cyloop.com"

set :market_404_page, "404_latino.html"
set :market_422_page, "422_latino.html"
set :market_500_page, "500_latino.html"
