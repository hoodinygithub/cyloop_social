
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
        artist.avatar_file_name = AvatarsHelper.avatar_path( object, :small )
      end
    end

  end


end