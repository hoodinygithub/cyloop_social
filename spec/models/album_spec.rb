require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Album do
  describe "#avatar" do
    it "should use the artist avatar as a fallback" do
      @album = Factory(:album)
      @album.owner.stub!(:avatar_file_name).and_return('owner_avatar_file_name')
      @album.avatar.should == @album.owner.avatar
    end

    it "should prefer its own avatar" do
      @album = Factory.create(:album)
      @album.stub!(:avatar_file_name).and_return('album_avatar_file_name')
      @album.owner.stub!(:avatar_file_name).and_return('owner_avatar_file_name')
      @album.avatar.should_not == @album.owner.avatar
    end
  end
end
