require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AlbumsController do
  integrate_views
  
  before(:all) do
    @artist = Factory(:artist, :name => "Dream Theater")
    @album  = Factory(:album, :owner => @artist, :artists => [@artist])
    @song   = Factory(:song, :artist => @artist, :album => @album)
    @user   = Factory(:user)
  end
  
  context 'GET index' do

    it 'should display artists album' do
      get :index, :slug => @artist.slug
      response.should be_success
    end
    
    it 'should be redirect to profile not found' do
      get :index, :slug => 'bad_slug'
      response.should be_redirect
    end
    
    it 'should be redirect to profile account when is user' do
      get :index, :slug => @user.slug
      response.should be_redirect
    end
    
  end
  
  context 'GET show' do

    it 'should render nothing' do
      get :show, :slug => nil, :id => 0
      response.should be_success
    end
    
    it 'should display album info' do
      get :show, :id => @album.to_param, :slug => @artist.slug
      response.should be_success
    end
    
    it 'should display song info' do
      get :show, :id => @album.to_param, :slug => @artist.slug, :song_id => @song.to_param
      response.should be_success
    end

    it 'should render a profile not found page when trying to view an album that does not exist' do
      get :show, :id => 'fake_album', :slug => @artist.slug
      response.should redirect_to( profile_not_found_path(@artist.slug) )
    end

    it 'should be redirect user path when trying to view a user album' do
      get :show, :id => @album.to_param, :slug => @user.slug
      response.should redirect_to( user_path(@user.slug) )
    end
    
  end
end
