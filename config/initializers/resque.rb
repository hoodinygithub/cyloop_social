rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

Dir[File.expand_path(File.join(rails_root,'vendor','cyqueue', 'app', 'jobs', '*.rb'))].each {|f| require f}

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]