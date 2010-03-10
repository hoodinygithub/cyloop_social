# == Schema Information
#
# Table name: regions
#
#  id         :integer(4)      not null, primary key
#  country_id :integer(4)
#  name       :string(255)
#  code       :string(10)
#

class Region < ActiveRecord::Base
  belongs_to :country
  has_many :cities

  def to_s
    "#{name}, #{country}"
  end
end
