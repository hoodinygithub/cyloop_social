tyrant_config = YAML.load(ERB.new(File.read("#{RAILS_ROOT}/config/tyrant.yml")).result)
TYRANT_CONFIG = tyrant_config[RAILS_ENV].symbolize_keys