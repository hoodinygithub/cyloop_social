class ChangeMexicoDefaultLocaleToEsMx < ActiveRecord::Migration
  def self.up
    execute <<-EOF
    UPDATE sites set default_locale = '--- :es_MX' 
    WHERE code = 'msnmx'
    EOF
  end

  def self.down
    execute <<-EOF
    UPDATE sites set default_locale = '--- :es' 
    WHERE code = 'msnmx'
    EOF
  end
end
