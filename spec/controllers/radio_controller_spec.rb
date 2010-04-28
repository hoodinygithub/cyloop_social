require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RadioController do
  integrate_views

  before do
    TopAbstractStation.destroy_all
    @top_stations = Factory(:top_station, :site_id => controller.send( :current_site ))
    @mock_recommendations_engine = mock('recommendations_engine')
    @songs = [ mock_model( Song ) ]
    @stations = [ mock_model( Station, :image => 'image', :artist_name => 'Sample', :amgID => 1, :station_url => 'url', :includes => [] ) ]
    @mock_recommendations_engine.stub!( :get_rec_engine_play_list ).and_return( @songs )
    @mock_recommendations_engine.stub!( :get_recommended_stations ).and_return( @stations )
    controller.stub!( :rec_engine ).and_return( @mock_recommendations_engine )

    Resque.stub!(:enqueue).and_return("OK")
  end

  context "GET index" do
    it "requires top stations" do
      get :index
      assigns[:top_stations].should include(@top_stations)
    end
    
    it 'requires a single station' do
      station = Factory(:station)
      get :index, :station_id => station.id
      assigns[:station_obj] == station
    end
    
    it 'requires an artists station' do
      artist = Factory.build(:artist, :name => "Test")
      
      Station.stub(:find).with(any_args).and_return(Factory.build(:station))
      Artist.stub(:find_by_name).with(artist.name).and_return(stub(:station => Factory.build(:station)))
      current_site = Factory.build(:cyloop_site)
      controller.stub(:current_site).and_return(current_site)

      get :index, :artist_name => artist.name
      assigns[:station_obj] == artist
    end
  end
  
  context 'GET twitstation' do
    it 'requires top stations' do
      get :twitstation
      assigns[:top_stations].should include(@top_stations)
    end
    
    it 'requires a single station' do
      station = Factory(:station)
      get :twitstation, :station_id => station.id
      assigns[:station_obj] == station
    end
    
    it 'requires an artists station' do
      artist = Factory(:artist, :name => "Test")
      station = Factory(:station, :artist => artist)
      get :twitstation, :artist_name => artist.name
      assigns[:station_obj] == artist
    end
    
    it 'should warn user when radio is not found' do
      get :twitstation, :station_id => '000'
      response.should be_redirect
      
      get :twitstation, :artist_name => 'bad artist'
      response.should be_redirect
    end
  end

  it 'requires show page' do
    station = Factory(:station)
    get :show, :station_id => station.id
  end
  
  context 'GET search' do

    before do
      @station = Factory.build(:station)
    end

    context 'as anonymous' do
      it 'An anonymous user trying to do a search' do
        get :search, :station_name => @station.name
        response.should be_redirect
      end

      it 'An anonymous user trying to do an Ajax search' do
        station = Factory.build(:station)
        Station.stub_chain(:available, :first).and_return(station)
        controller.stub(:logged_in?).and_return(false)
        xhr :post, :search, :station_name => station.name
        response.should be_success
      end

      it 'Search when station does not exists' do
        get :search, :station_name => 'bad station'
        flash[:error].should == "Could not find artist: bad station"
        response.should be_redirect
      end

      it 'Search with Ajax when station does not exists' do
        xhr :post, :search, :station_name => 'bad station'
        response.body.should == "Could not find artist: bad station"
      end
    
    end

    context 'as a logged in user' do
      before :all do
        @station = Factory.build(:station)
        Station.stub_chain(:available, :first).and_return(@station)
        controller.stub(:logged_in?).and_return(true)

        @user = Factory.build(:user, :status => 'registered')
        @user.stub(:create_user_station).and_return(Factory.build(:station))
        controller.stub(:current_user).and_return(@user)
      end
      
      it 'trying to do a search' do
        get :search, :station_name => @station.name
        response.should be_redirect
      end

      it 'trying to do an Ajax search' do
        Player::Station.stub(:from).with(any_args).and_return([])
        xhr :post, :search, :station_name => @station.name
        response.should be_success
      end
    end
  end
  
  context 'GET artist_info' do
    it 'requires artist info' do
      Account.stub(:find).with('10').and_return(Factory.build(:artist))
      controller.stub(:similar_artists).and_return([])
      get :artist_info, :artist_id => '10'
      response.should render_template('radio/_artist_info.html.haml')
    end
    
    it 'does not requires artist info' do
      get :artist_info, :artist_id => 999999
      response.should_not render_template('radio/_artist_info.html.haml')
    end
  end
end
