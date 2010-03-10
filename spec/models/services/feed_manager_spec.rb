require File.expand_path(File.join( File.dirname(__FILE__), '..', '..', 'spec_helper' ))

describe FeedManager do

  before :all do
    @msn_ca_en_news_full = Nokogiri::XML.parse( IO.read( File.join( RAILS_ROOT, 'spec', 'files', 'msn_ca_en_news_full.xml' ) ) )
    @msn_ca_en_news_four = Nokogiri::XML.parse( IO.read( File.join( RAILS_ROOT, 'spec', 'files', 'msn_ca_en_news_four.xml' ) ) )
  end

  describe 'on CA EN feeds loading' do

    before do
      @feed_manager = FeedManager.new( nil, nil, true )
    end

    describe 'with full list' do

      before do
        @feed_manager.stub!(:get).and_return( @msn_ca_en_news_full )
        @news = @feed_manager.get_single_msn_feed(6)
      end

      it "should have 'Swell Season Talk Sex, Success, Staying Grounded' as it's first item" do
        @news.first.title.should == 'Swell Season Talk Sex, Success, Staying Grounded'
      end

      it "should have 'Arctic Monkeys Coming Back To North America' as it's last feed item" do
        @news.last.title.should == 'Arctic Monkeys Coming Back To North America'
      end

      it 'should have six items' do
        @news.size.should == 6
      end

    end

    describe 'with a four items list' do

      before do
        @feed_manager.stub!(:get).and_return( @msn_ca_en_news_four )
        @news = @feed_manager.get_single_msn_feed(6)
      end

      it "should have 'Swell Season Talk Sex, Success, Staying Grounded' as it's first item" do
        @news.first.title.should == 'Swell Season Talk Sex, Success, Staying Grounded'
      end

      it "should have 'Wax Mannequin Destroyed Andy Magoffin's Studio' as it's last feed item" do
        @news.last.title.should == "Wax Mannequin Destroyed Andy Magoffin's Studio"
      end

      it 'should have six items' do
        @news.size.should == 4
      end

    end

  end

end
