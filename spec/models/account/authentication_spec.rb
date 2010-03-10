require File.dirname(__FILE__) + '/../../spec_helper'

describe Account::Authentication do
  it 'requires email' do
    Factory.build(:user, :email => '').should have(1).error_on(:email)
  end

  it 'requires password' do
    Factory.build(:user, :password => '').should have(1).error_on(:password)
  end

  it 'resets password' do
    @user = Factory(:user, :email => "quentin@example.com")
    @user.reset_password_to('new password')
    User.authenticate('quentin@example.com', 'new password').should == @user
    @user.destroy
  end

  it 'does not rehash password' do
    @user = Factory(:user, :email => "quentin@example.com", :password => 'test', :password_confirmation => 'test')
    @user.update_attributes(:email => 'quentin2@example.com')
    User.authenticate('quentin2@example.com', 'test').should == @user
    @user.destroy
  end

  it 'authenticates user' do
    @user = Factory(:user, :email => "quentin@example.com", :password => 'test')
    User.authenticate('quentin@example.com', 'test').should == @user
    @user.destroy
  end

  it 'sets remember token' do
    @user = Factory(:user)
    @user.remember_me
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    @user = Factory(:user)
    @user.remember_me
    @user.remember_token.should_not be_nil
    @user.forget_me
    @user.remember_token.should be_nil
  end

  it 'remembers me for one week' do
    @user = Factory(:user)
    before = 1.week.from_now.utc
    @user.remember_me_for 1.week
    after = 1.week.from_now.utc
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
    @user.remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    @user = Factory(:user)
    time = 1.week.from_now.utc
    @user.remember_me_until time
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
    @user.remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    @user = Factory(:user)
    before = 2.weeks.from_now.utc
    @user.remember_me
    after = 2.weeks.from_now.utc
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
    @user.remember_token_expires_at.between?(before, after).should be_true
  end

  it 'confirms a user' do
    code = Factory(:user).confirmation_code
    user = User.confirm(code)
    user.should be_confirmed
  end

  describe 'password update' do
    before :each do
      @valid_attributes = {:current_password => 'password', :password => 'test2', :password_confirmation => 'test2'}
      @email = "test#{rand*Time.now.to_i}@cyloop.com"
      @user = Factory.build(:user, :email => @email)
    end
    
    it 'should change password with valid information' do
      @user.save.should be_true
      @user.update_attributes(@valid_attributes)
      User.authenticate(@email, @valid_attributes[:password]).should == @user
    end
    
    it 'should not try to change the password if no new password is supplied' do      
      attributes_without_password = @valid_attributes
      attributes_without_password.delete(:password)
      @user.save.should be_true
      @user.update_attributes(attributes_without_password)
      User.authenticate(@email, @valid_attributes[:current_password]).should == @user
    end

  end

end
