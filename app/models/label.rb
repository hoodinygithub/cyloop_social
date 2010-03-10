# == Schema Information
#
# Table name: labels
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Label < ActiveRecord::Base
  has_many :artists
  has_many :albums
end
