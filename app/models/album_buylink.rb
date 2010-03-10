# == Schema Information
#
# Table name: album_buylinks
#
#  id                  :integer(4)      not null, primary key
#  album_id            :integer(4)
#  buylink_provider_id :integer(4)
#  url                 :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#


class AlbumBuylink < ActiveRecord::Base
  belongs_to :buylink_provider
  belongs_to :album
end
