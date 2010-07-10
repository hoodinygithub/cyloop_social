class PlaylistCopying < ActiveRecord::Base
  belongs_to :original_playlist, :class_name => "Playlist", :counter_cache => :playlist_copyings_count
  belongs_to :new_playlist, :class_name => "Playlist"
end