require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Following do
  it "should tie together two users in a followee/follower relationship" do
    @bob = Factory(:user, :name => "Bob")
    @amy = Factory(:user, :name => "Amy")
    Following.create :follower => @bob, :followee => @amy
    @bob.followees.should include(@amy)
  end
end
