class EditorialStation < ActiveRecord::Base
  include Station::Playable
  include EditorialStation::SitesAvailable

  belongs_to :mix, :class_name => 'Playlist', :foreign_key => :mix_id

  def playlist
    mix.try(:songs)
  end

  def includes(limit=3)
    mix.songs.all(:limit => limit).uniq_by { |s| s.artist_id } if mix.songs
  end

end
