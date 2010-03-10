set :application_url, "72.44.47.44"

role :app, application_url
role :web, application_url
role :db,  application_url, :primary => true

set :market_config_needed, true
set :nginx_server_name, "br.staging.cyloop.com"

# This will be substituted into nginx.conf for the environment
# wherever MARKET_ABBREV appears
set :market_abbrev, "br"
set :site, "MSN Brazil"

# This will be substituted into nginx.conf wherever MARKET_NAME
# appears.
set :market_name, "brazil"

set :market_404_page, "404_br.html"
set :market_422_page, "422.pt.html"
set :market_500_page, "500_br.html"