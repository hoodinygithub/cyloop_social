require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AlbumBuylinksController do
  before do
    @artist = Factory(:artist, :name => "Dream Theater")
    @album  = Factory(:album, :owner => @artist, :artists => [@artist])
    @album_buylinks = Factory(:album_buylink, :album => @album)
  end
  
  it 'requires show page' do
    get :show, :slug => @artist.slug, :id => @album.id
    assigns[:buylinks].should include(@album_buylinks)
    response.should be_success
  end
end