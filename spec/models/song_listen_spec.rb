require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SongListen do

  describe ".most_listened" do
    before do
      @site = Site.find_or_create_by_name('Cyloop')
      @listener = Factory(:user)
      @album = Factory(:album)
      2.times do |i|
        @listener.song_listens.create!(:song => Factory(:song), :total_listens => i+1, :site => @site, :album_id => @album)
      end
    end

    it "should have a ratio proportionate to the maximum listens" do
      pending "is this valid?"
      @listener.most_listened_songs.first.ratio.should == 1
      @listener.most_listened_songs.second.ratio.should == 1/2.0
    end

  end
end
