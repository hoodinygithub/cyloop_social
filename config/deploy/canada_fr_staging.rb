set :application_url, "72.44.47.44"

role :app, application_url
role :web, application_url
role :db,  application_url, :primary => true

set :market_config_needed, true
set :nginx_server_name, "ca_fr.staging.cyloop.com"

# This will be substituted into nginx.conf for the environment
# wherever MARKET_ABBREV appears
set :market_abbrev, "canada_fr"
set :site, "MSN Canada FR"

# This will be substituted into nginx.conf wherever MARKET_NAME
# appears.
set :market_name, "MSN Canada FR"

set :market_404_page, "404_ca_fr.html"
set :market_422_page, "422_ca_fr.html"
set :market_500_page, "500_ca_fr.html"
