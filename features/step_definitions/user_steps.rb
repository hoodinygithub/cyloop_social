Given 'a user' do
  @user = User.generate!
end

Given 'I go to an unexistent user profile' do
  visit "/an_unexistent_user_profile"
end

Given /^a user with (\d+) stations?$/ do |count|
  @user = User.generate!
  count.to_i.times do
    UserStation.create!(:owner => @user, :station => Station.generate!)
    UserStation.create!(:owner => @user, :station => Station.generate!)
  end
end

Given /^user (.+) has (\d+) stations?$/ do |user_name, count|
  @user = Account.find_by_slug(user_name)
  count.to_i.times do
    UserStation.create!(:owner => @user, :station => Station.generate!)
  end
end

Given 'the user is fully registered' do
  @user.finish_registration! if @user.just_created?
  Rails.cache.clear
end

Given 'I am logged in' do
  Factory(:site, :name => 'Cyloop', :default_locale => 'en') unless Site.exists?(:name => 'Cyloop')
  @user = User.generate!(:confirmation_code => nil, :status => 'registered')
  @current_user = @user
  Given 'the user is fully registered'
  post_via_redirect "/session", :email => @current_user.email, :password => @current_user.password
  Rails.cache.clear
end

When /^I sign in as (.*)$/ do |name|
  @user = User.find_by_name(name)
  @current_user = @user
  Given 'the user is fully registered'
  delete_via_redirect session_path
  post_via_redirect session_path, :email => @current_user.email, :password => @current_user.password || "password"
end

When /^I get my "(.*)" activity$/ do |activity_type|
  visit get_activity_path(:type => activity_type, :su => true, :sf => true, :user => @current_user.id)
end

When 'I log in with the account I just registered with' do
  @current_user = User.find_by_email("test@example.com")
end

When /^I log in with email "(.*)" and password "(.*)"$/ do |email, password|
  post_via_redirect session_path, :email => email, :password => password
end

Given 'I have a user with email "(.*)"' do |email|
  @user = Factory(:user, :email => email)
end

Given 'I have a deleted user with email "(.*)"' do |email|
  @user = Factory(:deleted_user, :email => email)
end

Given 'I have not activated my account' do
  @current_user.confirmation_code = 'abc123'
  @current_user.regenerate_confirmation_code
  @current_user.save
end

Given 'I have activated my account' do
  @current_user.update_attribute(:confirmation_code, nil)
  @current_user.update_attribute(:city_id, Factory(:city))
end

When 'I log out' do
  delete_via_redirect "/session"
end

Given /^I have a city$/ do
  city = Factory(:city, :location => 'Miami, FL')
  @current_user.update_attribute(:city_id, city.id)
end

Given /^my name is "(.*)"$/ do |name|
  @current_user.update_attribute(:name, name)
end

Given /^there is a user named "(.*)"$/ do |name|
  @user = User.find_by_name(name) || User.generate!(:name => name)
end

Then /^I should see a "(.+)" link/ do |action|
  response.body.should have_tag("a, button", "Follow")
end

Given /^I have (\d+) friends$/ do |count|
  count.to_i.times do
    @current_user.follow(Artist.generate!)
  end
end

Then /^I should see the message for an unconfirmed user$/ do
  response.body.should have_tag("#unconfirmed_user_warning")
end

Then /^I should see (\d+) followees on the side module$/ do |count|
  response.body.should have_tag(".following li", :count => count.to_i)
end

Then /^I should not see the message for an unconfirmed user$/ do
  response.body.should_not have_tag("#unconfirmed_user_warning")
end

# Cancel Account
Then /^I should be logged out$/ do
  @current_user.should nil
end

Then /^the account should be marked as deleted$/ do
  
end

Given /^I have a deleted user account$/ do
  @user = User.find_deleted_by_slug('deleted_user') || Factory(:deleted_user)
end

Then /^I should be redirect to the MSN Login Page and inform my account\.$/ do
  do_login_msn
end
