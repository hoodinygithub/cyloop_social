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
    mix.songs.all(:limit => limit).uniq_by { |s| s.artist_id } if mix.songs
  end
  
  def owner_is?(user)
    false
  end

  def station_queue(params={})
    "/sites_stations/#{id}.xml"
  end

end
