Then /^I should see (\d+) genres$/ do |count|
  response.body.should have_tag('.genre', :count => count.to_i)
end
