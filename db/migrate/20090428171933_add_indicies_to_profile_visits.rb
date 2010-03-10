class AddIndiciesToProfileVisits < ActiveRecord::Migration
  def self.up
    add_index :profile_visits, :owner_id
    add_index :profile_visits, :visitor_id
    add_index :profile_visits, :site_id
  end

  def self.down
    remove_index :profile_visits, :column => :owner_id
    remove_index :profile_visits, :column => :visitor_id
    remove_index :profile_visits, :column => :site_id
  end
end
