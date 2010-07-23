class AddArtistinfoNameHexToCampaigns < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE campaigns ADD artistinfo_name_hexcolor char(6)"
  end

  def self.down
    ActiveRecord::Base.connection.execute "ALTER TABLE campaigns DROP COLUMN artistinfo_name_hexcolor"
  end
end
