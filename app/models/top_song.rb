# == Schema Information
#
# Table name: top_songs
#
#  id            :integer(4)      not null, primary key
#  total_listens :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  site_id       :integer(4)
#  song_id       :integer(4)
#

class TopSong < ActiveRecord::Base
  include Summary::Predicates
  include Db::Predicates::LimitedTo
  belongs_to :site
  belongs_to :song, :foreign_key => :song_id
end
