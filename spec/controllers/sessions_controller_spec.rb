require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do
  integrate_views

  before do
    @site = mock( Site,
      :id => 1,
      :default_locale => :en,
      :name => 'MSN Brasil',
      :code => 'msnbr',
      :login_type_id => 2,
      :calendar_locale => :pt_BR )
    controller.stub!(:current_site).and_return( @site )
    controller.stub!( :wlid_web_login? ).and_return(true)
    Resque.stub!(:enqueue).and_return("OK")
  end
  
  describe 'User Authentication GET [new]' do
    
    it 'should login and redirect with msn_live_id already created' do
      @quentin = Factory(:user, :msn_live_id => do_login_msn)
      msn_live_id = do_login_msn
      get :new, :stoken => get_stoken
      session[:msn_live_id].should == msn_live_id
      response.should redirect_to('my/dashboard')
    end
    
    it 'should create msn login' do
      @quentin = Factory(:user, :msn_live_id => '')
      msn_live_id = do_login_msn
      get :new, :stoken => get_stoken
      response.should be_redirect
    end
    
    it 'should redirect to msn login url' do
      get :new, :stoken => nil
      response.should be_redirect
    end
    
    it 'should redirect to msn login url (invalid token)' do
      get :new, :stoken => "1234"
      response.should be_redirect
    end    
       
    it 'should not enable artist log in' do
      Account.stub(:find_by_msn_live_id_and_deleted_at).with(any_args).and_return(nil)
      get :new, :stoken => get_stoken
      response.should redirect_to('users/new')
    end
  end
  
  describe 'User Authentication GET [create]' do
        
    it 'should login and redirects' do
      msn_live_id = do_login_msn      
      @quentin = Factory(:user, :msn_live_id => msn_live_id)
      get :new, :stoken => get_stoken
      session[:msn_live_id].should == msn_live_id      
      response.should redirect_to('my/dashboard')
    end

  end
  
  describe 'User Authentication GET [destroy]' do

    it 'should log out' do
      msn_live_id = do_login_msn      
      @quentin = Factory(:user, :msn_live_id => msn_live_id)
      get :new, :stoken => get_stoken
      session[:msn_live_id].should == msn_live_id
      get :destroy
      response.should be_redirect
    end
    
  end
  
  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
end
