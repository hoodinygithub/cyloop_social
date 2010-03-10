require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Playlist do
  
  it "should return a total of seconds in the playlist" do
    user = Factory(:user)
    playlist = user.playlists.create :name => "Rick"
    playlist.items.create :song => Factory(:song, :length => 300)
    playlist.items.create :song => Factory(:song, :length => 490)
    playlist.items.create :song => Factory(:song, :length => 250)
    playlist.total_time.should == 1040
  end

end
