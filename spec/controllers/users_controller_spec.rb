require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  integrate_views

  before :all do
    load_sites
    @country = Country.find_or_create_by_name_and_code :name => 'United States', :code => "US"
    @region = @country.regions.create :name => 'Florida'
    @city = @region.cities.create :name => 'Miami'
  end

  before :each do
    Resque.stub!(:enqueue).and_return("OK")
  end

  context 'MSN Integration' do

    before do
      controller.stub!( :login_type ).and_return( 'wlid_web' )
    end

    it 'User Registration' do
      get :new
      response.should be_redirect
    end
    
    it 'Check MSN Authentication' do
      get :msn_login_redirect
      response.should be_redirect
    end
    
    it 'Check MSN Registration' do
      get :msn_registration_redirect
      response.should be_redirect
    end
  end

  context 'User Registration' do
    it 'errors on slug' do
      get :errors_on, :value => "quire@test.com", :field => :email
      response.should be_success
    end
    
    it 'errors on email' do
      get :errors_on, :value => "quire", :field => :slug
      response.should be_success
    end    

    it 'allow user signup when user is valid' do
      user = Factory.build(:user)
      UsersController.any_instance.stub!(:trim_attributes_for_paperclip).with(user.attributes, :avatar).and_return("")
      UsersController.any_instance.stub!(:current_user=).with(any_args())
      UserNotification.stub!(:send_registration).with(any_args).and_return(true)
      
      @user = mock_model(User)
      @user.stub!(:entry_point=).with(any_args())
      @user.stub!(:ip_address=).with(any_args())
      @user.stub!(:msn_live_id).with(any_args())
      @user.stub!(:save).and_return(true)
      @user.stub!(:twitter_username_changed?).and_return(false)
      User.stub!(:new).and_return(@user)
            
      post :create, :user => user.attributes
      response.should be_redirect
    end
    
    it 'does not allow user signup when user is valid' do
      user = Factory.build(:user)
      UsersController.any_instance.stub!(:trim_attributes_for_paperclip).with(user.attributes, :avatar).and_return("")
      UsersController.any_instance.stub!(:current_user=).with(any_args())
      UsersController.any_instance.stub!(:respond_to).with(any_args()).and_return(nil)
      UserNotification.stub!(:send_registration).with(any_args).and_return(true)
      
      user_attrs = user.attributes.merge(:password => '', 
                                         :password_confirmation => '', 
                                         :negative_captcha => '',
                                         :terms_and_privacy => false)
                                         
      @user = mock_model(User, user_attrs)
      @user.stub!(:entry_point=).with(any_args())
      @user.stub!(:errors).with(any_args()).and_return(user.errors)
      @user.stub!(:ip_address=).with(any_args())
      @user.stub!(:msn_live_id).with(any_args())
      @user.stub!(:save).and_return(false)
      @user.stub!(:twitter_username_changed?).and_return(false)
      User.stub!(:new).and_return(@user)
            
      post :create, :user => user.attributes
      response.should_not be_redirect
    end
    

    it 'allow user to remove your account' do
      delete :destroy, :feedback => "my feedback"
      response.should be_redirect
    end
  end

  context 'User Forgot Password' do
    it 'forgot password' do
      User.stub!(:find_by_email).with(any_args).and_return(Factory.build(:user))
      UserNotification.stub!(:send_reset_notification).with(any_args()).and_return(true)
      post :forgot, :user => {:email => "quire@example.com"}
      response.should be_redirect
    end
    
    it 'forgot password with an invalid email' do
      User.stub!(:find_by_email).with(any_args).and_return(false)
      post :forgot, :user => {:email => "quir,example.com"}
      response.should be_success
    end
  end

  context 'User Change Account' do

    it 'allow user to remove your account' do
      delete :destroy, :feedback => "my feedback"
      response.should be_redirect
    end

    it 'allow user to remove his avatar' do
      controller.stub!(:current_user).and_return(@user = Factory.build(:user))
      @user.stub!(:remove_avatar).and_return(true)
      get :remove_avatar
      flash[:success].should == "Your settings have been saved."
    end
    
    it 'does not allow user to remove his avatar when did not find the user' do
      controller.stub!(:current_user).and_return(@user = Factory.build(:user))
      @user.stub!(:remove_avatar).and_return(false)
      get :remove_avatar
      flash[:error].should == "Your settings failed to save."
    end
    

    it 'allow user to show your account' do
      get :show
      response.should redirect_to(:action => :edit)
    end

    it 'allow user to edit your account' do
      get :edit
    end

    it 'allow user to update your account' do
      controller.stub!(:current_user).and_return(@user = Factory.build(:user))
      @user.stub!(:save).and_return(true)
      
      post :update, :user => { :email => 'quire2009@example.com', :name => 'Quire McGuire' }
      flash[:success].should == "Your settings have been saved."
    end

    it 'update account with an invalid email' do
      controller.stub!(:current_user).and_return(@user = Factory.build(:user))
      @user.stub!(:save).and_return(false)
      
      put :update, :user => { :email => 'quire2009,example.com', :name => '' }
      flash[:error].should == "Your settings failed to save."
    end

    it 'does create a user at step 1' do
      def users_size 
        User.all.size 
      end
      
      before_size = users_size
      post :create, :user => Factory(:user).attributes
      users_size == before_size + 1
    end
  end
end
