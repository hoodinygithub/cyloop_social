require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Station do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :amg_id => "value for amg_id"
    }
    @artist = Factory(:artist)
  end

  it "should create a new instance given valid attributes" do
    Station.create!(@valid_attributes)
  end
  
  it 'should create a new station when is given an artist' do
    Station.create_station(@artist)
  end
  
  it 'should display the station name when is required' do
    station = Station.create!(@valid_attributes)
    assert_equal "value for name", station.to_s
  end
  
  it 'should include includes cache' do
    array = Station.included(Station.new)
    assert_equal Array, array
  end
end
