require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  
  it 'should not allow user to add a station they already have' do
    abs_station = Factory.build(:abstract_station)
    user = Factory(:user)
    user.stations.create!(:abstract_station => abs_station)

    lambda {
      user.stations.create!(:station => station)
    }.should raise_error
    user.destroy
  end

  it 'should receive follow notifications by default' do
    @user = User.new
    @user.receives_following_notifications.should == true
  end

  it 'should allow male as a gender' do
    @user = Factory.build(:user, :gender => 'Male').should have(:no).errors_on(:gender)
  end

  it 'should allow female as a gender' do
    @user = Factory.build(:user, :gender => 'Female').should have(:no).errors_on(:gender)
  end

  it 'should not allow non-genders' do
    @user = Factory.build(:user, :gender => 'alien').should have(1).error_on(:gender)
  end
  
  it "should not allow two users with the same slug" do
    User.destroy_all
    ReservedSlug.destroy_all
    AccountSlug.destroy_all
    
    user = Factory.build(:user, :slug => 'jason')
    user2 = Factory.build(:artist, :slug => 'jason')

    user.save.should be_true
    user2.save.should be_false
  end
  
  it "should not allow users with reserved slugs" do
    ReservedSlug.destroy_all
    reserved_slug = Factory(:reserved_slug)
    user  = Factory.build(:user, :slug => reserved_slug.slug)

    user.save.should be_false
    user.errors.on(:slug).should_not be_blank
  end  

  it 'should clear the customization key on save'
  
  it "should not allow users with the same twitter username" do
    user = Factory.build(:user, :twitter_username => 'daviscabral')
    user2 = Factory.build(:artist, :twitter_username => 'daviscabral')

    user.save.should be_true
    user2.save.should be_false
    user2.errors.on(:twitter_username).should_not be_blank
  end  

  it 'should get the cached follower ids correctly' do
    user = Factory(:user)
    user.followings.approved.map(&:followee_id).should == user.cached_followee_ids
    user.followings.pending.map(&:followee_id).should == user.cached_pending_followee_ids
  end
  
  it 'should return a correct age' do
    user = Factory(:user, :born_on => (Date.today - 15.years))
    user.age.should == 15
  end

  it 'should return a correct age with a date 29 years ago plus one day' do
    user = Factory(:user, :born_on => ((Date.today - 29.years) + 1.day))
    user.age.should == 28
  end

  it 'should create a user succcessfully' do
    User.destroy_all
    ReservedSlug.destroy_all
    AccountSlug.destroy_all
    
    u = Factory.build(:user)
    u.save.should be_true
  end

  it 'should use the user creation entry point locale as it\'s default locale' do
    site = Site.find_by_name('Cyloop')
    user = Factory(:user, :entry_point_id => site.id, :name => 'first user')
    user.default_locale.should == site.default_locale
  end

  it 'should return the user default locale if it has been set' do
    site = Site.find_by_name('Cyloop')
    user = Factory(:user, :entry_point_id => site.id, :default_locale => :pt, :name => 'second user')
    user.default_locale.should == :pt
  end
end
