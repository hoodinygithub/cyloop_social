class DbPerconaIndexEnhancements < ActiveRecord::Migration
  def self.up
    remove_index :song_listens, :column => :song_id
    remove_index :song_listens, :column => :artist_id
    add_index :song_listens, [:song_id, :listener_id, :site_id]
    add_index :song_listens, [:artist_id, :total_listens]
    add_index :song_listens, [:artist_id, :song_id, :total_listens]
    add_index :followings, [:followee_id, :updated_at]
    add_index :profile_visits, [:owner_id, :site_id, :visitor_id]
  end

  def self.down
    remove_index :song_listens, :column => [:song_id, :listener_id, :site_id]
    remove_index :song_listens, :column => [:artist_id, :total_listens]
    remove_index :song_listens, :column => [:artist_id, :song_id, :total_listens]
    remove_index :followings, :column => [:followee_id, :updated_at]
    remove_index :profile_visits, :column => [:owner_id, :site_id, :visitor_id]
    add_index :song_listens, :song_id
    add_index :song_listens, :artist_id
  end
end
