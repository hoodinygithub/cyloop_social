require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
=begin
describe ActivityFeed, "with one song listen item" do
  
  before(:each) do
    @time = Time.now
    @activity_feed = ActivityFeed.new(Factory(:user))
    @activity_feed.stub!(:read_file).and_return(["666|listen|42|#{@time.to_i}|>"])
  end
  
  it "should provide one activity item in a collection for a given user" do
    pending
    @activity_feed.lines.size.should == 1
  end
  
  it "should provide user from the line in the user's activity_feed file" do
    pending
    User.should_receive(:find).with("666").and_return(user=stub(:user))
    @activity_feed.lines.first.user.should == user
  end
  
  it "should provide song that was listened to from the line in the user's activity_feed file" do
    pending
    Song.should_receive(:find).with("42").and_return(song=stub(:song))
    @activity_feed.lines.first.item.should == song
  end
  
  it "should provide the time that the song was listened to from the line in the user's activity_feed file" do
    pending
    @activity_feed.lines.first.timestamp.should == Time.at(@time.to_i)
  end
end
=end