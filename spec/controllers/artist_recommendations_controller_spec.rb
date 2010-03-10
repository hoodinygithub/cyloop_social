require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArtistRecommendationsController do

  integrate_views
  
  before do
    @current_user = Factory(:user)
    @current_user.update_attribute(:status, 'registered')
    login_as @current_user
    @recommendations = [ mock( RecEngine::Artist, :image => 'image', :id => 1, :nick_name => 'name', :profile_url => '/artist' ) ]
    @rec_engine = mock( 'rec_engine', :get_recommended_artists => @recommendations )
    controller.stub!(:rec_engine).and_return( @rec_engine )
  end

  def do_get
    get :show
  end

  it 'should call the recommendations engine' do
    @rec_engine.should_receive(:get_recommended_artists).and_return(@recommendations)
    do_get
  end

  it 'should display artists recommendations' do
    do_get
    assigns[:artists].should == @recommendations
  end

end
