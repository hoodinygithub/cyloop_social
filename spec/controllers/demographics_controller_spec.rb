require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DemographicsController do
  before do
    @current_user = Factory(:user)
    @current_user.update_attribute(:status, 'registered')
    login_as @current_user
  end
  
  it 'requires edit page' do
    get :edit
    assigns[:user].should == @current_user
  end
  
  it 'requires update page' do
    get :update, :user => { :name => "" }
    response.should render_template('demographics/edit')
    
    get :update, :user => { :name => "Samir" }
    response.should redirect_to(artist_recommendations_path)
  end
  
  it 'requires search for cities' do
    get :cities, :q => "Miami"
    response.body.should match(/Miami/)
  end
end
