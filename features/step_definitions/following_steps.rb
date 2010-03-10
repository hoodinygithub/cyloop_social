Given /^I am following (\d+) users$/ do |count|
  count.to_i.times do
    @current_user.followees << User.generate!
  end
  @current_user.followee_count = @current_user.followees.size
  @current_user.save!
end

Given /^user "(.+)" is following (\d+) users$/ do |user_name,count|
  account = Account.find_by_slug(user_name)
  count.to_i.times do
    account.followees << User.generate!
  end
end

Given /^I am following these (users|artists)$/ do |user_type,table|
  table.hashes.each do |row|
    followee = Account.find_by_slug(row['slug']) == nil ? user_type.singularize.classify.constantize.generate!(:slug => row['slug'], :name => row['name'], :deleted_at => row['deleted_at']) : Account.find_by_slug(row['slug'])
    if user_type == "artists"
      Bio.generate! :account_id => followee.id
    end
    # followee.follow(@current_user)
    # @current_user.reload
    # puts @current_user.followers.inspect
    Following.create! :follower => @current_user, :followee => (followee), :created_at => row['started following']
  end
end

Given /^user (.+) is following these (users|artists)$/ do |user_name,user_type,table|
  user = Account.find_by_slug(user_name)
  table.hashes.each do |row|
    followee = Account.find_by_slug(row['slug']) == nil ? user_type.singularize.classify.constantize.generate!(:slug => row['slug'], :name => row['name']) : Account.find_by_slug(row['slug'])
    if user_type == "artists"
      Bio.generate! :account_id => followee.id
    end
    Following.create! :follower => user, :followee => (followee), :created_at => row['started following']
  end
end

Given /^I am following a user$/ do
  @followed_user = User.generate!
  Following.destroy_all(:conditions => {:follower_id => @current_user.id})
  @current_user.follow(@followed_user)
end

Given /^I am following "(.*)"$/ do |user_name|
  Given "there is a user named \"#{user_name}\""
  When "I go to #{user_name}'s page"
  When 'I click "Follow"'
end

Given /^I have (\d+) followers/ do |count|
  count.to_i.times do
    User.generate!.follow @current_user
  end
end

Given /^(.+) follows (\d+) users/ do |user_name, count|
  user = Account.find_by_name(user_name) || Account.find_by_slug!(user_name)
  count.to_i.times do
    user.follow User.generate!
  end
end

Given /^user "(.+)" has (\d+) followers/ do |user_name, count|
  user = Account.find_by_slug(user_name)
  count.to_i.times do
    User.generate!.follow user
  end
end

Given /^I have a follower named "(.*)"$/ do |user_name|
  Given "there is a user named \"#{user_name}\""
  @user.follow(@current_user)
  Given 'I am on my followers page'
  Then "I should see \"#{user_name}\""
end

When /^for user "(.*)" I click the button "(.*)"$/ do |user_name, link|
  user = User.find_by_name user_name
  within "#user_#{user.id}" do |li|
    li.click_button link
  end
end

When /^for user "(.*)" I click the username$/ do |user_name|
  user = User.find_by_name user_name
  within "#user_#{user.id} .username" do |li|
    li.click_link user_name
  end
end

When /^for user "(.*)" I click the photo$/ do |user_name|
  user = User.find_by_name user_name
  within "#user_#{user.id} .avatar" do |li|
    li.click_link user_name
  end
end

Then /^I should see (\d+) followees$/ do |count|
  response.body.should have_tag("#followees .user", :count => count.to_i)
end

Then /^I should see (\d+) followers$/ do |count|
  response.body.should have_tag("#followers .user", :count => count.to_i)
end

Then /^I should see these followees in order$/ do |table|
  followees_test = ""
  table.raw.each_with_index do |row, index|
    name = row[0]
    followees_test += "#{name}.*"
    # response.body.should have_selector("#followees li:nth-child(#{index+1})") do |li|
    #   li.inner_text.should =~ /#{name}/
    # end
  end
  response.body.should =~ /#{followees_test}/m
end

Then /^followee "(.+)" should be highlighted$/ do |name|
  response.body.should have_tag("#artist_#{Artist.find_by_name(name).id}.following")
end

Then /^followee "(.+)" should not be highlighted$/ do |name|
  response.body.should_not have_tag("#artist_#{Artist.find_by_name(name).id}.following")
end

Then /^I should be following "(.*)"$/ do |name|
  #user_name = Account.find_by_name(name)
  flash[:success].should == "You are now following #{name}"
end

Then /^I should not be following "(.*)"$/ do |user_name|
  flash[:success].should == "You are no longer following #{user_name}"
end

Then /^I should not be followed by "(.*)"$/ do |user_name|
  Given 'I am on my followers page'
  Then "I should not see \"#{user_name}\""
end
