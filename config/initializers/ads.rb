ads_zones = YAML.load(ERB.new(File.read("#{RAILS_ROOT}/config/ads_zones.yml")).result)
ADS_ZONES = ads_zones.symbolize_keys