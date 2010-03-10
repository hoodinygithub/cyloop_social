require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Activity::Twitter do
  before(:each) do
    @user = Factory(:user)
  end
  
  before(:all) do
    @used_keys = []
  end
  
  after(:all) do
    @used_keys.each{|key| Activity::Twitter.db.out(key)}
  end
  
  describe "content" do
    before(:each) do
    end    
  end
  
  describe "my own twitter activity" do
    before(:each) do
      @activity_feed = Activity::Twitter.new(@user.twitter_id)
      @used_keys.push(@activity_feed.key)
    end
  end  
end