# == Schema Information
#
# Table name: album_artists
#
#  id         :integer(4)      not null, primary key
#  album_id   :integer(4)
#  artist_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

  # == Schema Information
#
# Table name: album_artists
#
#  id         :integer(4)      not null, primary key
#  album_id   :integer(4)
#  artist_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class AlbumArtist < ActiveRecord::Base
  include Db::Predicates::LimitedTo
  belongs_to :artist
  belongs_to :album
end
