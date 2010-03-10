config_file = File.join(RAILS_ROOT, 'config', 'memcached_expiration_times.yml')
expiration_times = YAML::load(ERB.new(File.read(config_file)).result)[RAILS_ENV] unless defined?(EXPIRATION_TIMES)
# expiration_times.each {|k,v| expiration_times[v] = eval(v)}
EXPIRATION_TIMES = expiration_times