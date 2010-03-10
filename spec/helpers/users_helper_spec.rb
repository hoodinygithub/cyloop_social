require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module UsersHelper
  include ButtonHelper
end

describe UsersHelper do
  describe "#follow_button" do
    describe "on radio page with a artist without a station" do
      before(:each) do 
        @artist  = Factory(:artist)          
        @artist.stub!(:station).and_return(nil)        
        @station = Factory(:station)
        Artist.stub!(:find).and_return(@artist)
        request.stub!(:request_uri).and_return("/radio/info/#{@station.artist.id}")
      end
      
      def logout
        helper.should_receive(:logged_in?).and_return(false)
      end
      
      def login
        @current_user = Factory(:user)        
        helper.should_receive(:logged_in?).and_return(true)
        helper.should_receive(:current_user).exactly(2).times.and_return(@current_user)        
      end

      describe "and logged out" do          
        it "should redirect to /radio if artist don't have station and there is no current_station" do
          logout
          helper.follow_button(@artist, :current_station => nil).match("%2Fradio").should_not be_nil
        end            
        
        it "should redirect to the current station if artist don't have station and there is a current_station" do
          logout          
          helper.follow_button(@artist, :current_station => @station.id).match("%2Fmy%2Fstations%2F#{@station.id}%2Fqueue").should_not be_nil
        end        
      end
      
      describe "and logged in" do
        it "should redirect to /radio if artist don't have station" do
          login
          helper.follow_button(@artist).should have_tag("form[action^=?]", "/my/following")
        end            
      end      
    end    
  end
end