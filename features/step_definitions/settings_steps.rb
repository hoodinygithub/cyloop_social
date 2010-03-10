Given /^a filled out user settings form$/ do
  Given 'I go to my settings page'
end

Given /^my password is "(.*)"$/ do |password|
  @current_user.reset_password_to password
end

When /^I am not receiving following notifications$/ do
  @current_user.update_attribute(:receives_following_notifications, false)
end

Then /^I should be receiving following notifications$/ do
  @current_user.reload # TODO: Clean me
  @current_user.receives_following_notifications.should == true
end

Then /^I should not be receiving following notifications$/ do
  @current_user.reload # TODO: Clean me
  @current_user.receives_following_notifications.should == false
end

Then /^I should have website "(.*)"$/ do |website|
  response.body.should have_selector("input[type=text][value='#{website}']")
end


