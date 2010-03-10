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
set :nginx_server_name, "ec2.latino.cyloop.com latino.msn.cyloop.com production.latino.hoodiny.com latino.cyloop.msn.com"

set :market_404_page, "404_latino.html"
set :market_422_page, "422_latino.html"
set :market_500_page, "500_latino.html"

after "deploy:setup", :configure_nginx_ssl
after "deploy:setup", :copy_ssl_certs_to_data

desc "Copies the HTTP SSL certs into place for nginx"
task :copy_ssl_certs_to_data do
  sudo "mkdir -p /data/ssl"
  sudo "cp /root/restore/ssl.cyloop.com.* /data/ssl"
end

desc "Copies ssl configuration into place for US Latino market"
task :configure_nginx_ssl, :roles => :app do
  
  # Make sure that the environment file is filled out correctly.
  [:market_name, :market_abbrev].each do |sym|
    raise RuntimeError, "Make sure to define #{sym} in the deploy environment file!" unless exists?(sym)
  end
  
  configuration_modified = false

  # This file shouldn't be around for any app server, delete it if it exists.
  nginx_default_file = "/etc/nginx/sites-enabled/default"
  if remote_file_exists?(nginx_default_file)
    sudo "rm #{nginx_default_file}" 
    configuration_modified =true
  end
  
  nginx_contents = ERB.new(File.read(File.join(File.dirname(__FILE__), %w[.. external nginx uslatino.ssl.conf.erb]))).result(binding)
  nginx_market_path = '/etc/nginx/sites-available/uslatino.ssl.conf.erb'
  
  if remote_file_differs?(nginx_market_path, nginx_contents)
    upload(StringIO.new(nginx_contents), '/tmp/uslatino.ssl.conf.erb')
    sudo "mv /tmp/uslatino.ssl.conf.erb #{nginx_market_path}"
    configuration_modified = true
  end
  
  activate_market_symlink = "/etc/nginx/sites-enabled/uslatino.ssl.conf.erb"
  unless remote_symlink_exists?(activate_market_symlink)
    sudo "ln -s /etc/nginx/sites-available/uslatino.ssl.conf.erb #{activate_market_symlink}"
    configuration_modified = true
  end
  
  sudo "/etc/init.d/nginx reload" if configuration_modified

end