require File.dirname(__FILE__) + '/../../spec_helper'

describe Account do

  describe "Following functionality of a User" do
    before do
      @user = Factory(:user)
      @another_user = Factory(:user)
    end
    
    it "should provide a follow method that follows another user" do
      @user.follow(@another_user)
      @user.followees.should include(@another_user)
    end
    
    it "should provide a follows? method that checks if a user is being followed" do
      @user.follow(@another_user)
      @user.follows?(@another_user).should be_true
      @user.follows?(Factory(:user)).should_not be_true
    end
    
    it "should add the id of the new followee to its followee_cache" do
      @user.followee_cache.should be_empty
      @user.follow(@another_user)
      @user.reload
      @user.followee_cache.should include(@another_user.id)
    end
  end

end
