require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchesController do
  
  before(:all) do
    @user   = Factory(:user, :name => "Samir")
    @artist = Factory(:artist, :name => "Dream Theater")
    @album  = Factory(:album, :name => "Awake", :owner => @artist, :artists => [@artist])
    @song   = Factory(:song, :title => "6:00", :artist => @artist, :album => @album)
  end
  
  it 'should search an artist' do
    get :show, :scope => "artist", :q => "Dream Theater"
    assigns[:results].should include(@artist)
    response.should be_success
  end
  
  it 'should search an user' do
    get :show, :scope => "user", :q => "Samir"
    assigns[:results].should include(@user)
    response.should be_success
  end
  
  it 'should search an album' do
    get :show, :scope => "albums", :q => "Awake"
    assigns[:results].should include(@album)
    response.should be_success
  end
  
  it 'should search a song' do
    get :show, :scope => "songs", :q => "6:00"
    assigns[:results].should include(@song)
    response.should be_success
  end
  
end