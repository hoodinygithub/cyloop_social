When /^I block a user named "(.*)"$/ do |blockee_name|
  Given "there is a user named \"#{blockee_name}\""
  Given "I have a follower named \"#{blockee_name}\""
  Given "I am on my followers page"
  within "#user_#{@user.id}" do |scope|
    scope.click_link "Block"
  end
  click_button "Block"
  Given "I am on my followers page"
end

When /^I unblock a user named "(.*)"$/ do |blockee_name|
  Given "there is a user named \"#{blockee_name}\""
  block = @current_user.blocks.find(:first, :conditions => {:blockee_id => @user.id})
  visit my_dashboard_path
  visit my_block_path(block), :delete
end

When /^I am blocked by "(.*)"$/ do |blockee_name|
  Given "there is a user named \"#{blockee_name}\""
  @user.block(@current_user)
end

Then /^I should have (\d+) blocks?$/ do |block_count|
  @current_user.blocks.count.should == block_count.to_i
end

Then /^I should be blocking "(.*)"$/ do |user_name|
  @current_user.blocks?(User.find_by_name(user_name)).should == true
end

Then /^I should not be blocking "(.*)"$/ do |user_name|
  @current_user.blocks?(User.find_by_name(user_name)).should == false
end
