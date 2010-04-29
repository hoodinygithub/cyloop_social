# == Schema Information
#
# Table name: player_bases
#
#  name             :string
#  avatar_file_name :
#  slug             :
#  name             :string
#  avatar_file_name :
#  slug             :
#


class Player::Artist < Player::Base

  column :name, :string
  column :avatar_file_name
  column :slug

  def to_xml(options = {})
    options[:root] = 'artist'
    super
  end

  class << self

    def from_one( object, options = {} )
      returning(super(object, options)) do |artist|
        if(object.respond_to? :artist)
          artist.avatar_file_name = AvatarsHelper.avatar_path( object.artist, :small )
        else
          artist.avatar_file_name = AvatarsHelper.avatar_path( object, :small )
        end
      end
    end

  end


end
