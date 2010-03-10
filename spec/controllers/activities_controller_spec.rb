require File.dirname(__FILE__) + '/../spec_helper'

describe ActivitiesController do

  describe 'on GET get_activity calls' do

    before do
      @user = User.generate!
      @song = Song.generate!
      @activities = [ { 'item' => { 'id' => @song.id }, 'type' => 'listen', 'timestamp' => Time.now.to_i } ]
      @account = mock( User, :transformed_activity_feed => @activities )
      controller.stub!( :account ).and_return( @account )
    end

    def do_get
      get :get_activity, :user => @user.id, :type => 'all', :su => 'true', :sf => 'false'
    end

    it 'should be a success' do
      do_get
      response.should be_success
    end

    it 'should render the all_activities template' do
      do_get
      response.should render_template('modules/activity/_all_activity')
    end

    it 'should get the parsed activity' do
      @account.should_receive( :transformed_activity_feed ).and_return( @activities )
      do_get
    end

    it 'should set the activities' do
      do_get
      assigns[:activities].should == @activities
    end

    it 'should find the songs' do
      do_get
      assigns[:activities].first['record'].should == @song
    end

  end

end