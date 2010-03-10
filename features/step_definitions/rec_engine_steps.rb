require 'spec/mocks/framework'
require 'spec/mocks/extensions'

class RecEngine
  include Spec::Mocks::ExampleMethods

  def get_recommended_artists(options = {})
    db_artist = ::Artist.first

    unless db_artist.nil?
      artist = mock('artist', :null_object => true,
                              :name => db_artist.name, 
                              :id => db_artist.id)
    else
      artist = mock('artist', :null_object => true, :id => 1)
    end

    [artist] * (options[:number_of_records] || 5)
  end
  
  def get_recommended_stations(options = {})
    artist = mock('artist', :null_object => true,
                            :artist_name => 'TEST ARTIST', 
                            :image => '/storage/storage?fileName=/.elhood.com-2/usr/9417/image/thumbnail/MANA 10_rgb.jpg',
                            :artist_id => 1,
                            :station_url => '#',
                            :includes => [{:name => 'test', :url => '/test'}]
                            )
    [artist] * 3
  end

end
