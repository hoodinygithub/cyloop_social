require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
=begin
describe ActivityStore do
  before(:each) do
    @user   = Factory(:user)
    @song   = Factory(:song)#Song.find(item_id, :select => 'id, file_name, label, title, artist_id, album_id')
    @album  = {
      :artist_id => @song.artist_id, 
      :song_id   => @song.id, 
      :user_id   => @user.id,
      :activity  => ActivityProxy::Writer.new(@user, @song).serialize
    }    
  end
  
  it 'should serialize the data as json before storing' do
    pending "Someone broke this"
    input = {'activity' => {:album => @album}}
    expected_output = input.to_json
    ActivityStore.store(@user, input)
    ActivityStore.first.data.should == expected_output
  end
  
  it 'should find data in created_at descending order' do
    pending "Someone broke this"
    
    first_in = @album
    last_in  = Factory(:album)
    first_time = 2.minutes.ago.utc
    last_time = 1.minute.ago.utc
    Time.stub!(:now).and_return(first_time)
    ActivityStore.store(@user, first_in)
    Time.stub!(:now).and_return(last_time)
    ActivityStore.store(@user, last_in)
    ActivityStore.all.first.data.should == last_in.to_json
    ActivityStore.all.last.data.should == first_in.to_json
  end
  
  it 'should store activity for a user' do
    ActivityStore.store(@user, @album)
    @user.activity_feed.should_not be_nil
  end
  
  it 'should something something' do
    ActivityStore.store(@user, @album)
    lambda { @user.parsed_activity_feed }.should_not raise_error
  end
  
  it 'should also something' do
    pending "Someone broke this"
    
    payload = {
      :artist_id => @song.artist_id, 
      :song_id   => @song.id, 
      :user_id   => @user.id,
      :activity  => nil
    }
    ActivityStore.store(@user, payload)
    lambda { @user.parsed_activity_feed }.should_not raise_error
    @user.parsed_activity_feed.size.should == 0
  end
end
=end