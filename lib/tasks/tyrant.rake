namespace :tyrant do
  desc "Start tyrant. Not really for use in production environment."
  task :start => :environment do
    `rm -f #{RAILS_ROOT}/db/tyrant/#{RAILS_ENV}.pid`
    port = TYRANT_CONFIG[:hosts].first.split(':').last
    ttcomand = "ttserver -dmn "
    ttcomand << "-port #{port} "
    ttcomand << "-log #{RAILS_ROOT}/log/tyrant.#{RAILS_ENV}.log "
    ttcomand << "-pid #{RAILS_ROOT}/db/tyrant/#{RAILS_ENV}.pid "
    ttcomand << "#{RAILS_ROOT}/db/tyrant/#{RAILS_ENV}.tct"
    puts ttcomand
    exec ttcomand
    pid = `cat #{RAILS_ROOT}/db/tyrant/#{RAILS_ENV}.pid`
    puts "Running ttserver in #{RAILS_ENV} environment with pid #{pid}"
  end
  
  task :stop => :environment do
    `kill -TERM \`cat #{RAILS_ROOT}/db/tyrant/#{RAILS_ENV}.pid\``
  end
end