require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SongBuylinksController do
  before(:all) do
    @artist = Factory(:artist, :name => "Dream Theater")
    @album  = Factory(:album, :owner => @artist, :artists => [@artist])
    @song   = Factory(:song, :artist => @artist, :album => @album)
    @song_buylink = Factory(:song_buylink, :song => @song)    
    @buylink_providers_site = Factory(:buylink_providers_site, :buylink_provider => @song_buylink.buylink_provider)
    @site   = Site.find_by_name('Cyloop')
  end
  
  it 'requires show page' do
    get :show, :id => @song.id
    assigns[:buylinks].should include(@song_buylink)
  end
  
end