# For complete deployment instructions, see the following support guide:
# http://www.engineyard.com/support/guides/deploying_your_application_with_capistrano

require "eycap/recipes"
require 'new_relic/recipes'
require 'tinder'

# =================================================================================================
# ENGINE YARD REQUIRED VARIABLES
# =================================================================================================
# You must always specify the application and repository for every recipe. The repository must be
# the URL of the repository you want this recipe to correspond to. The :deploy_to variable must be
# the root of the application.

set :keep_releases,       5
set :application,         ENV['DEPLOY_SITE'] || ARGV[0]
set :deploy_base,         "/data"
set :shared_base,         "/shared"
set :user,                "hoodiny"
set :password,            "Xh00d17ME71z"
set :deploy_to,           "#{deploy_base}/#{application}"
set :monit_group,         ENV['DEPLOY_SITE'] || ARGV[0]
set :runner,              "hoodiny"
set :repository,          "git@github.com:hoodinygithub/cyloop_social.git"
set :cyqueue,             "/data/cyqueue/current"

set :git_shallow_clone,   1

set :scm,                 :git
set :real_revision,       lambda { source.query_revision(revision) { |cmd| capture(cmd) } }
set :production_database, "cyloop_production"
set :production_dbhost,   "cyloop-db-new_enzo"
set :staging_database,    "cyloop_staging"
set :staging_dbhost,      "cyloop-db-new_enzo"
set :dbuser,              "hoodiny_db"
set :dbpass,              "Q97t42WGDj8a"

set :shared_path,         "#{deploy_to}/shared"
set :sites,               [
                              "mexico_cs", "brazil_cs", "canada_fr_cs", "canada_en_cs", 
                              "cyloop_cs", "cyloopes_cs", "latino_cs", "latam_cs", "tvn_cs", 
                              "argentina_cs"
                          ]


# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

# =================================================================================================
# ROLES
# =================================================================================================
# You can define any number of roles, each of which contains any number of machines. Roles might
# include such things as :web, or :app, or :db, defining what the purpose of each machine is. You
# can also specify options that can be used to single out a specific subset of boxes in a
# particular role, like :primary => true.

set :branch, "master"

#EY06 All Sites
task :production do
  role :app, "72.46.233.77:7005", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7006", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7007", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7008", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7009", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7010", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7011", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7000", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7016", :no_release => true, :no_symlink => true
  role :app, "72.46.233.77:7017", :no_release => true, :no_symlink => true

  set :branch, "release-20100505"
  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 Brazil
task :brazil do
  role :web, "72.46.233.77:7005"
  role :app, "72.46.233.77:7005", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7005", :primary => true
  role :app, "72.46.233.77:7006", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 Mexico
task :mexico do
  role :web, "72.46.233.77:7007"
  role :app, "72.46.233.77:7007", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7007", :primary => true
  role :app, "72.46.233.77:7008", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 Latam
task :latam do
  role :web, "72.46.233.77:7009"
  role :app, "72.46.233.77:7009", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7009", :primary => true
  role :app, "72.46.233.77:7010", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end


#EY06 US Latin
task :latino do
  role :web, "72.46.233.77:7011"
  role :app, "72.46.233.77:7011", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7011", :primary => true
  role :app, "72.46.233.77:7000", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 Argentina
task :argentina do
  role :web, "72.46.233.77:7011"
  role :app, "72.46.233.77:7011", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7011", :primary => true
  role :app, "72.46.233.77:7000", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 US Cyloop.com
task :cyloop do
  role :web, "72.46.233.77:7011"
  role :app, "72.46.233.77:7011", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7011", :primary => true
  role :app, "72.46.233.77:7000", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 Canada
task :canada do
  role :web, "72.46.233.77:7016"
  role :app, "72.46.233.77:7016", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7016", :primary => true
  role :app, "72.46.233.77:7017", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 TVN
task :tvn do
  role :web, "72.46.233.77:7016"
  role :app, "72.46.233.77:7016", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7016", :primary => true
  role :app, "72.46.233.77:7017", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 Widget
task :widget do
  role :web, "72.46.233.77:7016"
  role :app, "72.46.233.77:7016", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7016", :primary => true
  role :app, "72.46.233.77:7017", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

#EY06 Cyloop ES
task :cyloopes do
  role :web, "72.46.233.77:7016"
  role :app, "72.46.233.77:7016", :memcached => true, :sphinx => true
  role :db , "72.46.233.77:7016", :primary => true
  role :app, "72.46.233.77:7017", :memcached => true, :sphinx => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

task :staging do
  role :web, "72.46.233.74:7000"
  role :app, "72.46.233.74:7000", :memcached => true, :sphinx => true
  role :db , "72.46.233.74:7000", :primary => true

  set :rails_env, "staging"
  set :environment_database, defer { staging_database }
  set :environment_dbhost, defer { staging_dbhost }
end

desc "Create all remaining symlinks"
task :symlink_remaining, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
  run <<-CMD
    rm -rf #{latest_release}/db/sphinx &&
    mkdir -p #{latest_release}/db/ &&
    ln -s #{shared_path}/system/db/sphinx #{latest_release}/db/sphinx &&
    rm #{latest_release}/config/memcached.yml &&
    ln -s #{shared_path}/config/memcached.yml #{latest_release}/config/memcached.yml &&
    ln -s #{shared_path}/config/passenger_cluster.yml #{latest_release}/config/passenger_cluster.yml &&
    ln -s #{shared_path}/config/resque.yml #{latest_release}/config/resque.yml
  CMD

  if ['staging','production'].include?(rails_env)
    #db symlinks
    run <<-CMD
      rm -rf #{latest_release}/db/fixtures &&
      ln -s #{shared_path}/system/db/fixtures #{latest_release}/db/fixtures &&
      rm -rf #{latest_release}/db/geoip &&
      ln -s #{shared_path}/system/db/geoip #{latest_release}/db/geoip
    CMD

    site_code = case application
                  when /^mexico/    then "mx";   
                  when /^brazil/    then "br";
                  when /^latam/     then "latam";
                  when /^latino/    then "latino";
                  when /^cyloopes/  then "es";
                  when /^cyloop/    then "cyloop";
                  when /^argentina/ then "ar";
                  when /^canada_en/ then "ca_en";
                  when /^canada_fr/ then "ca_fr";
                  when /^tvn/       then "tvn";
                  when /^widget/    then "widget";
                end

    run <<-CMD
      rm -rf #{latest_release}/public/404.html && rm -rf #{latest_release}/public/404.html && rm -rf #{latest_release}/public/422.html && rm -rf #{latest_release}/public/500.html &&
      ln -s #{latest_release}/public/400_#{site_code}.html #{latest_release}/public/400.html &&
      ln -s #{latest_release}/public/404_#{site_code}.html #{latest_release}/public/404.html &&
      ln -s #{latest_release}/public/422_#{site_code}.html #{latest_release}/public/422.html &&
      ln -s #{latest_release}/public/500_#{site_code}.html #{latest_release}/public/500.html &&
      rm #{latest_release}/public/robots.txt &&
      ln -s #{shared_path}/robots.txt #{latest_release}/public/robots.txt && 
      ln -s #{shared_path}/system/sitemap.xml #{latest_release}/public/sitemap.xml &&
      ln -s #{shared_path}/system/sitemap_style.xls #{latest_release}/public/sitemap_style.xls
    CMD
  end
end

namespace :deploy do
  
  # Try and get around EY gem
  task :symlink_configs, :roles => :app, :except => {:no_release => true} do
    run <<-CMD
      cd #{latest_release} &&
      rm -rf #{latest_release}/lib/tasks/hoptoad_notifier_tasks.rake &&
      ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml
    CMD
  end
  
  task :symlink_cyqueue do
    run "ln -nfs #{cyqueue} #{latest_release}/vendor/cyqueue"
  end

  task :pre_announce do
    campfire_notification "#{ENV['USER']} is preparing to deploy #{application} to #{rails_env} (#{branch})"
  end

  task :post_announce do
    campfire_notification "#{ENV['USER']} finished deploying #{application} to #{rails_env} (#{branch})"
  end

  task :restart do
    run "touch #{latest_release}/tmp/restart.txt"
  end

  task :save_current_branch do
    if rails_env == 'staging'    
      run "echo '#{application} - #{branch}' > #{shared_path}/current_branch.log"
      run "ln -s #{shared_base}/common_cs/deployments.txt #{latest_release}/public/deployments.txt"      
    end
  end
  
  task :build_release_html, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
    if rails_env == 'staging'
      deployments_file = "#{shared_base}/common_cs/deployments.txt"
      run "echo 'CURRENT STAGING BRANCHES' > #{deployments_file}"
      sites.each do |site| 
        run "cat #{shared_base}/#{site}/current_branch.log >> #{deployments_file}"
      end
    end
  end  
end

# =================================================================================================
# desc "Example custom task"
task :hoodiny_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
  sudo <<-CMD
     /usr/bin/rake -f #{latest_release}/Rakefile gems:install RAILS_ENV=#{rails_env}
  CMD
end
#
# after "deploy:symlink_configs", "hoodiny_custom"
# =================================================================================================

#before "deploy:migrations", "deploy:pre_announce"
after "deploy:symlink_configs", "symlink_remaining" #,"symlink_sites"

# Do not change below unless you know what you are doing!
after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"
after "deploy:update_code", "deploy:pre_announce", "deploy:symlink_configs", "newrelic:notice_deployment"

after "deploy:symlink", "thinking_sphinx:symlink", "deploy:post_announce", "deploy:save_current_branch", "deploy:build_release_html"
before 'deploy:symlink_configs', 'deploy:symlink_cyqueue'
after "deploy:symlink_configs", "hoodiny_custom"

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"

def campfire_notification( message )
  begin
    unless @room
      @campfire = Tinder::Campfire.new 'hoodiny1', :ssl => true, :token => '3aa7fc18eaa511bfeb21fdae602e3ec175ecab2c'
      @room = @campfire.find_room_by_name 'Team'
    end
    @room.speak message
  rescue => e
    puts "Error trying to paste to Campfire -> #{e.message} (#{e.class})"
  end
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end 

require 'hoptoad_notifier/capistrano'
