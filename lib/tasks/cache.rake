namespace :cache do
 desc 'Clear memcache cache'
 task :clear => :environment do
   Rails.cache.clear
   # commented out due to the fact that we are not using cache-money for now.
   # $memcache.flush_all
 end
end