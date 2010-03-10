# Deploys to EC2 using the Capistrano multistage extension.
# Server configurations for individual stages are located in config/deploy.

# A typical deploy to a new server will look like this:

# Set up deploy directory structure:
# cap -f config/deploy_ec2.rb brazil deploy:setup

# Install additional gems needed by the app, as configured in environment.rb:
# cap -f config/deploy_ec2.rb brazil gems:install

# Deploy the app to "current" directory
# cap -f config/deploy_ec2.rb brazil deploy

# We're bypassing the Capfile since this is a secondary deployment script,
# so manually load the deploy library here.
load 'deploy' if respond_to?(:namespace)

require 'erb'

# Automatically creates a "_staging" stage for each stage that is configured.
set :stages, %w(brazil latino utility canada_en canada_fr mexico latam).inject([]){ |r, e| r << e << "#{e}_staging" }

# Make sure that deploy files exist for each stage and give a useful error if user forgets to set one up.
stages.each do |s|
  raise "Make sure a file exists in deploy for #{s}" unless File.exist?(File.join(File.dirname(__FILE__), 'deploy', "#{s}.rb"))
end

set :default_stage, 'brazil'

require 'capistrano/ext/multistage'
require 'capistrano/jsl/cm'

set :keep_releases, 10

set :application, "cyloop3"

set :scm, :git
set :user, 'hoodiny'

set(:deploy_to) { "/data/#{application}/#{stage}" }

set :use_sudo, false

set :repository, "git@github.com:hoodinygithub/cyloop3.git"

set :repository_cache, "git_cache"
set :deploy_via, :remote_cache

# When we migrate, trace any errors
set :migrate_env, "--trace"

namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    run "cd #{current_release} && #{sudo} rake gems:install"
  end
end

before "deploy:setup", :initialize_shared_config
after "deploy:setup", :configure_market

namespace :deploy do
  after "deploy:update", "deploy:cleanup"

  desc "Restart the Passenger system."
  task :restart, :roles => :app do
    passenger.restart
  end
end

namespace :passenger do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy:update_code", :set_market_symlinks

namespace :mysql do
  desc "Start local MySQL daemon for testing or for staging environments and saves setting for next boot"
  task :start, :roles => :app do
    sudo "update-rc.d mysql defaults"
    sudo "/etc/init.d/mysql start"
  end

  desc "Stop local MySQL daemon for testing or for staging environments and saves setting for next boot"
  task :stop, :roles => :app do
    sudo "update-rc.d -f mysql remove"
    sudo "/etc/init.d/mysql stop"
  end
end

desc "Sets the symlinks to international pages based on the configured market"
task :set_market_symlinks, :roles => :app do
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/passenger_cluster.yml #{release_path}/config/passenger_cluster.yml"

  puts "Setting market symlinks... (#{market_config_needed})"

  if market_config_needed
    # Bail with a useful error if the user forgot to define any one of the necessary market-specific 
    # error pages in the environment deploy file.
    [404, 422, 500].each do |code|
      market_code_page = "market_#{code}_page"
      raise RuntimeError, "Make sure to define #{market_code_page} in the deploy environment file!" unless exists?(market_code_page.to_sym)
    
      link_name = "#{latest_release}/public/#{code}.html"
      target = "#{latest_release}/public/#{eval(market_code_page)}"
    
      run "rm -rf #{link_name}"
      
      run "ln -s #{target} #{link_name}"
    end
  end
  
  # TODO - set up sitemap generation (on each app server?)
  # puts "Generating initial sitemap.xml..."
  # run "cd #{release_path} && RAILS_ENV=ec2_production rake sitemap:create"
end

desc "Configures the shared directory"
task :initialize_shared_config do
  sudo "mkdir -p #{deploy_to}/#{shared_dir}/config"  
  sudo "cp /root/restore/cyloop3_database.yml #{deploy_to}/#{shared_dir}/config/database.yml"
  sudo "chown -R hoodiny.hoodiny /mnt/data"
  sudo "chmod 644 #{deploy_to}/#{shared_dir}/config/database.yml"
end

desc "Does market specific setup, which includes preparing the nginx.conf and copying locale-specific files into place"
task :configure_market, :roles => :app do
  if market_config_needed
    # Make sure that the environment file is filled out correctly.
    [:market_name, :market_abbrev, :nginx_server_name].each do |sym|
      raise RuntimeError, "Make sure to define #{sym} in the deploy environment file!" unless exists?(sym)
    end
    
    configuration_modified = false

    # Sets the SITE in passenger_cluster.yml
    passenger_cluster_contents = ERB.new(File.read(File.join(File.dirname(__FILE__), %w[external passenger passenger_cluster.yml.erb]))).result(binding)
    passenger_cluster_config_path = "#{deploy_to}/#{shared_dir}/config/passenger_cluster.yml"
    
    # Update the passenger cluster yml file if needed, no nginx reload required
    if remote_file_differs?(passenger_cluster_config_path, passenger_cluster_contents)
      upload(StringIO.new(passenger_cluster_contents), '/tmp/passenger_cluster.yml')
      sudo "mv /tmp/passenger_cluster.yml #{passenger_cluster_config_path}"
    end

    nginx_market_filename = "#{stage}.conf"
    # This file shouldn't be around for any app server, delete it if it exists.
    nginx_default_file = "/etc/nginx/sites-enabled/default"
    if remote_file_exists?(nginx_default_file)
      sudo "rm #{nginx_default_file}" 
      configuration_modified =true
    end
    
    rails_environment = stage.to_s =~ /staging/ ? 'ec2_staging' : 'ec2_production'
    
    nginx_contents = ERB.new(File.read(File.join(File.dirname(__FILE__), %w[external nginx nginx_app_servers.conf.erb]))).result(binding)
    nginx_market_path = "/etc/nginx/sites-available/#{nginx_market_filename}"    
    
    if remote_file_differs?(nginx_market_path, nginx_contents)
      upload(StringIO.new(nginx_contents), "/tmp/#{nginx_market_filename}")
      sudo "mv /tmp/#{nginx_market_filename} #{nginx_market_path}"
      configuration_modified = true
    end
    
    activate_market_symlink = "/etc/nginx/sites-enabled/#{nginx_market_filename}"
    unless remote_symlink_exists?(activate_market_symlink)
      sudo "ln -s /etc/nginx/sites-available/#{nginx_market_filename} #{activate_market_symlink}"
      configuration_modified = true
    end
    
    sudo "/etc/init.d/nginx reload" if configuration_modified
  end

end