require File.dirname(__FILE__) + '/../spec_helper'

describe StationsController do
  integrate_views
  
  before(:each) do
    @station = Factory(:station)
  end
  
  it 'should be enable to search a station by name' do
    get :index, :q => "Station"
    response.should be_success
  end
end