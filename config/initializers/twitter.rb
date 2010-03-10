twitter_config = YAML.load(ERB.new(File.read("#{RAILS_ROOT}/config/twitter.yml")).result)
TWITTER_CONFIG = twitter_config[RAILS_ENV].symbolize_keys