Before do
  ActionMailer::Base.deliveries = []
end

Then /^I should receive (\d+) emails?$/ do |count|
  EmailJob.should_receive(:queue).exactly(count).times
  EmailJob.should_receive(:process).exactly(count).times
  ActionMailer::Base.any_instance.should_receive(:deliver).exactly(count).times
end

Then /^"(.*)" should receive (\d+) emails?$/ do |address, count|
  EmailJob.should_receive(:process).exactly(count).times
  # ActionMailer::Base.deliveries.select {|x| x.to.include?(address)}.should have(count.to_i).items
end

When 'I follow the link in the email' do
  # violated "No email was sent" unless ActionMailer::Base.deliveries.any?
  # get_via_redirect ActionMailer::Base.deliveries.last.body[%r{http://[^/]*?(/[^\s"]*)},1]
  true
end
