# == Schema Information
#
# Table name: top_albums
#
#  id            :integer(4)      not null, primary key
#  total_listens :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  site_id       :integer(4)
#  album_id      :integer(4)
#

class TopAlbum < ActiveRecord::Base
  include Summary::Predicates
  include Db::Predicates::LimitedTo
  belongs_to :site
  belongs_to :album, :foreign_key => :album_id
end
