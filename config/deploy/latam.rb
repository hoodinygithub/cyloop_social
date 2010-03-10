set :application_url, "72.44.47.44"

role :app, application_url
role :web, application_url
role :db,  application_url, :primary => true

set :market_config_needed, true
set :nginx_server_name, "ec2.latam.cyloop.com latam.cyloop.com latam.msn.cyloop.com  production.latam.hoodiny.com latam.cyloop.msn.com"

# This will be substituted into nginx.conf for the environment
# wherever MARKET_ABBREV appears
set :market_abbrev, "latam"
set :site, "MSN Latam"

# This will be substituted into nginx.conf wherever MARKET_NAME
# appears.
set :market_name, "latam"

set :market_404_page, "404_latam.html"
set :market_422_page, "422.es.html"
set :market_500_page, "500_latam.html"