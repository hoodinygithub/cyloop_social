class AddHeaderHexToCampaigns < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE campaigns ADD header_hexcolor char(6)"
  end

  def self.down
    ActiveRecord::Base.connection.execute "ALTER TABLE campaigns DROP COLUMN header_hexcolor"
  end
end
