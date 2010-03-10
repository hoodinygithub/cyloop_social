require File.dirname(__FILE__) + '/../../spec_helper'

describe "Playlists index page" do

  it "should have a properly formatted timestamp for a playlist's created_at" do
    pending
    @playlist = Factory(:playlist, :created_at => DateTime.parse("2009-01-03 16:00"))
    assigns[:playlists] = Playlist.paginate(:all, :page => 1)
    render 'playlists/index'
    
    response.body.should match(/3 months ago/)
  end
  
end
