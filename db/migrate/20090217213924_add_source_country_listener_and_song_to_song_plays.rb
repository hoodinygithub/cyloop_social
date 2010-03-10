class AddSourceCountryListenerAndSongToSongPlays < ActiveRecord::Migration
  def self.up
    add_column :song_plays, :source, :string
    add_column :song_plays, :country_id, :integer
    add_column :song_plays, :listener_id, :integer
    add_column :song_plays, :song_id, :integer
    add_column :song_plays, :site_id, :integer
    
    remove_column :song_plays, :updated_at
  end

  def self.down
    remove_column :song_plays, :site_id
    remove_column :song_plays, :song_id
    remove_column :song_plays, :listener_id
    remove_column :song_plays, :country_id
    remove_column :song_plays, :source
  end
end
