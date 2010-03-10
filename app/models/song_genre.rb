# == Schema Information
#
# Table name: song_genres
#
#  id         :integer(4)      not null, primary key
#  song_id    :integer(4)
#  genre_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class SongGenre < ActiveRecord::Base
  belongs_to :song
  belongs_to :genre
end
