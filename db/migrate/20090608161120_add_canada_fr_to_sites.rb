class AddCanadaFrToSites < ActiveRecord::Migration
  def self.up
    execute <<-EOF
    INSERT INTO sites(name, created_at, updated_at, default_locale, code)
    VALUES('MSN Canada FR', now(), now(), '--- :fr_CA', 'msncafr')
    EOF
  end

  def self.down
    transaction do
      max_id = select_one("SELECT max(id) AS max_id FROM sites")["max_id"].to_i
      execute "DELETE FROM sites WHERE code = 'msncafr'"
      execute "ALTER TABLE sites AUTO_INCREMENT=#{max_id}"
    end
  end
end
