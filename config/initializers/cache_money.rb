# if ['test', 'uat'].include?(RAILS_ENV)
#   # Stub this out for the test environment.
  class ActiveRecord::Base
    def self.index(*args)
    end
  end
# else
#   # require 'memcache'
#   # require 'cache_money'
#   
#   config = YAML.load(ERB.new(IO.read(File.join(RAILS_ROOT, "config", "memcached.yml"))).result)[RAILS_ENV]
#   $memcache = MemCache.new(config.merge(:logger => Rails.logger))
#   $memcache.servers = config['servers']
#   
#   $local = Cash::Local.new($memcache)
#   $lock = Cash::Lock.new($memcache)
#   $cache = Cash::Transactional.new($local, $lock)
# 
#   # class ActiveRecord::Base
#   #   def self.index(*args)
#   #   end
#   # end
# 
#   class ActiveRecord::Base
#     is_cached :repository => $cache
#   end
# end