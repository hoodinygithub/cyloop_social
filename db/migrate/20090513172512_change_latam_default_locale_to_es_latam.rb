class ChangeLatamDefaultLocaleToEsLatam < ActiveRecord::Migration
  def self.up
    execute <<-EOF
    UPDATE sites set default_locale = '--- :es_LATAM' 
    WHERE code = 'msnlatam'
    EOF
  end

  def self.down
    execute <<-EOF
    UPDATE sites set default_locale = '--- :es' 
    WHERE code = 'msnlatam'
    EOF
  end
end
