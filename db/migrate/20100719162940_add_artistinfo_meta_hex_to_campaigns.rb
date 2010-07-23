class AddArtistinfoMetaHexToCampaigns < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE campaigns ADD artistinfo_meta_hexcolor char(6)"
  end

  def self.down
    ActiveRecord::Base.connection.execute "ALTER TABLE campaigns DROP COLUMN artistinfo_meta_hexcolor"
  end
end
