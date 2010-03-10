require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomArtistsController do
  before(:all) do
    @detour   = Factory(:artist, :name => "detour")
    @invasion = Factory(:artist, :name => "invasion")
  end
  
  it 'should display detour page' do
    get :detour
    response.should render_template('custom_artists/show')
  end
  
  it 'should display invasion page' do
    get :invasion
    response.should render_template('custom_artists/show')
  end
  
end