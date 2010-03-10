set :application_url, "72.44.47.44"

role :app, application_url
role :web, application_url
role :db,  application_url, :primary => true

set :market_config_needed, true
set :nginx_server_name, "ec2.canada.en.cyloop.com music.ca.msn.cyloop.com ca.en.msn.cyloop.com production.ca.en.hoodiny.com music.ca.cyloop.msn.com"

# This will be substituted into nginx.conf for the environment
# wherever MARKET_ABBREV appears
set :market_abbrev, "canada_en"
set :site, "MSN Canada EN"

# This will be substituted into nginx.conf wherever MARKET_NAME
# appears.
set :market_name, "MSN Canada EN"

set :market_404_page, "404_ca_en.html"
set :market_422_page, "422_ca_en.html"
set :market_500_page, "500_ca_en.html"