class EditorialStation < ActiveRecord::Base
  include Station::Playable
  include EditorialStation::SitesAvailable

  belongs_to :mix, :class_name => 'Playlist', :foreign_key => :playlist_id

  def playlist
    mix.songs unless mix.nil?
  end

end
