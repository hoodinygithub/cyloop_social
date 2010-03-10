class DropRawProfileVisits < ActiveRecord::Migration
  def self.up
    drop_table :raw_profile_visits
  end

  def self.down
    create_table :raw_profile_visits do |t|
      t.integer :owner_id
      t.integer :visitor_id
      t.integer :site_id
      t.string :visitor_ip_address
      t.timestamps
    end
  end
end
