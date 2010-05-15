# == Schema Information
#
# Table name: editorial_stations
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  available     :boolean(1)
#  mix_id        :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  total_plays   :integer(4)      default(0), not null
#  total_artists :integer(4)      default(0), not null
#
class EditorialStation < ActiveRecord::Base
  include Station::Playable

  belongs_to :mix, :class_name => 'Playlist', :foreign_key => :mix_id
  delegate :name, :owner, :to => :mix
  
  def playlist
    mix.try(:songs)
  end

  def includes(limit=3)
    if mix.songs
      Rails.cache.fetch("#{cache_key}/includes/#{limit}", :expires_delta => EXPIRATION_TIMES['editorial_station_includes']) do
        mix.songs.all(:limit => limit, :include => [:artist, :album]).uniq_by(&:artist_id)
      end
    else
      []
    end
  end
  
  def owner_is?(user)
    false
  end

  def station_queue(params={})
    "/sites_stations/#{id}.xml"
  end

end
