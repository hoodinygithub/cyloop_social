require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# def includes(limit=3)
#   refresh_included_artists if total_artists < 1
# 
#   Rails.cache.fetch("#{cache_key}/includes/#{limit}", :expires_delta => EXPIRATION_TIMES['abstract_station_includes']) do
#     abstract_station_artists.all(:limit => limit)
#   end
# end

describe AbstractStation do
  before :each do
    @abstract_station = AbstractStation.new
  end
  
  it "should return a top abstract station" do
    TopAbstractStation.stubs(:first).with(any_parameters).returns(TopAbstractStation.new)
    @abstract_station.top_station.should be_a(TopAbstractStation)
  end
  
  it "should create a new station" do
    AbstractStation.stubs(:new).with(any_parameters).returns(true)
    @artist = Factory.build(:artist)
    AbstractStation.create_station(@artist).should be_true
  end
end