# == Schema Information
#
# Table name: top_artists
#
#  id            :integer(4)      not null, primary key
#  created_at    :datetime
#  updated_at    :datetime
#  total_listens :integer(4)
#  site_id       :integer(4)
#  artist_id     :integer(4)
#

class TopArtist < ActiveRecord::Base
  include Summary::Predicates
  set_inheritance_column nil
  
  belongs_to :site
  belongs_to :artist, :foreign_key => :artist_id
end
