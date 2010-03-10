Given /^I go to (.+)'s activity feed$/ do |username|
  visit "/activity/activity/all?format=js&user=#{Account.find_by_name!( username ).id}"
end

Given /^I am on (.+) page$/ do |page_specifier|
  When "I go to #{page_specifier} page"
end

Then /^I should see the following (.+) activity$/ do |activity_type,table|
  # puts response.body
  table.hashes.each do |hash|
    response.body.should have_selector("li." + activity_type + ".activity") { |li|
      li.inner_html.include?(hash["song_name"]).should be_true
      li.inner_html.include?(hash["artist_name"]).should be_true
      li.inner_html.include?(hash["listener_name"]).should be_true
    } 
  end
end

Then /^I should not see the following (.+) activity$/ do |activity_type,table|
  table.hashes.each do |hash|
    response.body.should_not have_selector("li." + activity_type + ".activity") { |li|
      li.inner_html.should_not include(hash["song_name"])
      li.inner_html.should_not include(hash["artist_name"])
      li.inner_html.should_not include(hash["listener_name"])
    } 
  end
end

Then /^I should see (\d+) (.+) activity items$/ do |activity_count,activity_type|
  response.body.should have_tag("li." + activity_type + ".activity", :count => activity_count.to_i)
end

Then /^I should see my avatar$/ do ||
  response.should have_tag('img[alt*=?]', @current_user.name)
end

When /^I click the link for the user "(.+)"$/ do |user_name|
  user = User.find_by_name user_name
  click_link user_name
  # within "#user_#{user.id}" do |li|
  #    li.click_link user_name
  #   end
end
