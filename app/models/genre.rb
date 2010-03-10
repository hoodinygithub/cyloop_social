# == Schema Information
#
# Table name: genres
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  key        :string(255)
#  parent_id  :integer(4)
#  top        :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class Genre < ActiveRecord::Base
  belongs_to :parent
  has_many :artists
  has_many :song_genres
  has_many :songs, :through => :song_genres
  index :id
end
