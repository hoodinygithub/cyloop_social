require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivityProxy do
  before(:each) do
    @user = Factory(:user)
    @song = Factory(:song)
  end
  
  it 'should not throw an error' do
    lambda {
      ActivityProxy::Writer.new(@user, @song).get_json
    }.should_not raise_error
  end
  
  it 'should not throw an error with a nil artist' do
    @song.artist = nil
    lambda {
      ActivityProxy::Writer.new(@user, @song).get_json
    }.should_not raise_error
  end
end