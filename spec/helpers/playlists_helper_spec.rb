require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlaylistsHelper do
  it "should return the length of time in seconds" do
    helper.length_of_time_from_seconds(300).should == "05:00"
  end
end
