require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  describe 'on slug generation' do
    before :each do
      User.destroy_all
      @account = Factory(:user)
    end

    it 'should generate a slug once an acount is created' do
      @account.account_slugs.first.slug.should == @account.slug
    end

    it 'should delete the slug when the account gets deleted' do
      @account.cancel_account!
      @account.account_slugs.should be_blank
    end

    it 'should set the account state to deleted' do
      @account.cancel_account!
      @account.status.should == 'deleted'
    end
  end
  
  context "any instance" do
    before :each do
      @city    = Factory.build(:city)
      @account = Factory.build(:user, :city => @city)
      @activity_feed_params = {:group => :all, :page => 1, :kind => :status}
    end
    
    it "should have a city_name" do
      @account.city_name.should_not be_nil
      @account.city_name.should == @city.location
    end
    
    it "should answer as registered" do
      @account.stubs(:status).returns("registered")
      @account.registered?.should be_true
    end

    it "should not answer as registered" do
      @account.stubs(:status).returns("other")
      @account.registered?.should be_false
    end
    
    it "should execute query if passing valid params" do
      Activity::Feed.stubs(:query).with(any_parameters).returns([])
      @account.activity_feed(@activity_feed_params).should == []
    end
    
    it "should raise an exception when using an unexistent group" do
      invalid_params = @activity_feed_params.merge({:group => 'noexist'})
      lambda {@account.activity_feed(invalid_params)}.should raise_error(ArgumentError)
    end
    
    it "should raise an exception when using an unexistent kind" do
      invalid_params = @activity_feed_params.merge({:kind => 'noexist'})
      lambda {@account.activity_feed(invalid_params)}.should raise_error(ArgumentError)
    end
    
    it "should create first_name using the name attribute" do
      @account.name = "Test User"
      @account.first_name == "Test"
    end
    
    it "should return the bio properly" do
      bio_item = Object.new
      bio_item.stubs(:long).returns("Testing value with \n char into it")
      
      bios_object = Object.new
      bios_object.stubs(:find_by_locale).with("--- :en").returns(bio_item)
      @account.stubs(:bios).returns(bios_object)
      
      @account.biography.should == "Testing value with <br/> char into it"
    end
    
    it "should be avaialble at current site" do
      sites = []
      sites.stubs(:count).with(any_parameters).returns(10)
      @account.stubs(:sites).returns(sites)
      @account.available_at_current_site?(1).should be_false
    end
    
    it "should be avaialble at current site" do
      sites = []
      sites.stubs(:count).with(any_parameters).returns(0)
      @account.stubs(:sites).returns(sites)
      @account.available_at_current_site?(1).should be_true
    end

    it "should set city_name if a valid name is provided" do
      @city = Factory.build(:city)
      City.stubs(:search).with(@city.name).returns([@city])
      @account.city_name = @city.name
      @account.city_name.should == @city.location
    end
    
    it "should be visible when available at site" do
      @account.stubs(:available_at_current_site?).returns(true)
      @account.visible?.should be_true
    end
    
    it "should not be visible when available at site" do
      @account.stubs(:available_at_current_site?).returns(false)
      @account.visible?.should be_false
    end
  end
  
  context "an user" do
    it "should answer as an user" do
      @account = User.new
      @account.user?.should be_true
    end
    
    it "should not answer as an artist" do
      @account = User.new
      @account.artist?.should be_false
    end
    
    context 'determining account_ids' do
      before :each do
        @account = Factory(:user)
        @account.stubs(:follower_ids).returns([1, 2, 3])
        @account.stubs(:followee_cache_not_deleted).returns([4, 5, 6])
      end

      it "should deterime ids to :just_following group" do
        @account.stubs(:blocker_ids).returns([])
        account_ids = @account.determine_account_ids(:just_following)
        account_ids.should == [4, 5, 6]
      end
      
      it "should deterime ids to :just_me group" do
        @account.stubs(:blocker_ids).returns([])
        account_ids = @account.determine_account_ids(:just_me)
        account_ids.should == [@account.id]
      end
      
      it "should deterime ids to :all" do
        @account.stubs(:blocker_ids).returns([])
        account_ids = @account.determine_account_ids(:all)
        account_ids.should == [@account.id, 4, 5, 6]
      end

      it "should prevent to return blocked users" do
        @account.stubs(:blocker_ids).returns([5])
        account_ids = @account.determine_account_ids(:all)
        account_ids.should == [@account.id, 4, 6]
      end
    end
  end
  
  context "an artist" do
    it "should answer as an artist" do
      @account = Artist.new
      @account.artist?.should be_true
    end

    it "should not answer as an user" do
      @account = Artist.new
      @account.user?.should be_false
    end
    
    context 'determining account_ids' do
      before :each do
        @account = Artist.new
        @account.stubs(:follower_ids).returns([1, 2, 3])
        @account.stubs(:followee_cache_not_deleted).returns([4, 5, 6])
      end

      it "should deterime ids to :just_following group" do
        @account.stubs(:blocker_ids).returns([])
        account_ids = @account.determine_account_ids(:just_following)
        account_ids.should == [1, 2, 3]
      end
      
      it "should deterime ids to :just_me group" do
        @account.stubs(:blocker_ids).returns([])
        account_ids = @account.determine_account_ids(:just_me)
        account_ids.should == [@account.id]
      end
      
      it "should deterime ids to :all" do
        @account.stubs(:blocker_ids).returns([])
        account_ids = @account.determine_account_ids(:all)
        account_ids.should == nil
      end
    end
  end
end