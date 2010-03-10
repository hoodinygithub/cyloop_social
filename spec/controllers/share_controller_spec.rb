require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ShareController do

  before do
    @artist = Factory(:artist, :name => "Dream Theater")
    @album  = Factory(:album, :owner => @artist, :artists => [@artist])
    @song   = Factory(:song, :artist => @artist, :album => @album)
  end

  describe 'on show calls' do

    it 'should display shared content' do
      get :show, :media => "song", :id => @song.id
      assigns[:item].should == @song
      response.should render_template('share/song')
    end

  end

  describe 'on share_with_friend calls' do

    before do
      Resque.stub!(:enqueue).and_return("OK")
    end

    def do_post( friend_emails = 'test@example.com' )
      post :share_with_friend, :message => "message test",
        :item_author => @artist.name,
        :item_title => @song.title,
        :item_id => @song.id,
        :user_email => "test@example.com",
        :media => "song",
        :authenticity_token => "eF+7tAzETUexnBp/eiq0JgZVemXjH96cY3vfjU+/has=",
        :share_link => "http://test.host/#{@artist.slug}/albums/#{@album.to_param}/#{@song.to_param}",
        :user_name => "Samir",
        :friend_email => friend_emails
    end

    it 'should be a success' do
      do_post
      response.should render_template('confirmation')
    end

    it 'should send shared content' do
      UserNotification.should_receive( :send_share_song ).and_return( true )
      do_post
    end

    it 'should send an email for each friend email' do
      UserNotification.should_receive(:send_share_song).exactly(3).times
      do_post( 'mauricio@gmail.com, jose@gmail.com, ana@gmail.com' )
    end

    it 'should create a shared_song' do
      do_post
      SharedSong.first( 
        :conditions => {
          :sender_email => 'test@example.com',
          :song_id => @song.id,
          :recipient_email => 'test@example.com' } ).should_not be_blank
    end

  end

end