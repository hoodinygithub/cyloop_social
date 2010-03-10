When /^I go to "([^\"]*)"$/ do |page_name|
  visit path_to(page_name)
end

When /^I go to (.+) page$/ do |page_name|
  visit path_to(page_name)
end

When /^I go to "(.*)" path$/ do |url|
  visit url
end

When /^I go to the playlists page for "(.*)"$/ do |playlist_name|
  visit my_playlist_path(Playlist.find_by_name(playlist_name))
end

Then /^I should be prompted to log in$/ do
  URI.parse(current_url).path.should include(new_session_path)
end

Then /^I should be on the "(.*)" album page for "(.*)"$/ do |album_name, artist_name|
  artist = Artist.find_by_name(artist_name)
  album = Album.find_by_name_and_owner_id(album_name,artist.id)
  URI.parse(current_url).path.should == artist_album_path(artist, album)
end

Then /^I should not be on (.+) page$/ do |page_name|
  URI.parse(current_url).path.should_not == path_to(page_name)
end

When /^I click "(.*)"$/ do |label|
  begin
    click_button(label)
  rescue Webrat::NotFoundError
    click_link(label)
  end
end

When /^for "(.+)" I click "(.*)"$/ do |user_name,label|
  user = Account.find_by_name(user_name)
  within "#user_#{user.id}" do |scope|
    begin
      scope.click_button(label)
    rescue Webrat::NotFoundError
      scope.click_link(label)
    end
  end
end

When /^I fill in "(.*)" with a date within the last (\d+) years$/ do |field, age|
  fill_in(field, :with => age.to_i.years.ago + 1.month)
end

When /^the current time is "(.*)"$/ do |current_time|
  @current_time = DateTime.parse(current_time)
end

Then /^the input field for "(.*)" of type "(.*)" should have autocomplete turned "(.*)"$/ do |field, type, toggle|
  response.body.should have_tag("input[type='#{type}'][name='#{field}'][autocomplete='#{toggle}']")
end

Then /^the radio button "(.*)" for "(.*)" should be chosen$/ do |value, field|
  response.body.should have_tag("input[type='radio'][name='#{field}'][value='#{value}'][checked='checked']")
end

When /^I attach the "(.*)" file at "(.*)" to "(.*)"$/ do |type, path, field|
  attach_file(field, File.expand_path(File.join(File.dirname(__FILE__), "..", path)), type)
end

Then /^"(.*)" should match against the HTML$/ do |data|
  response.body.match(data).should_not == nil
end

Then /^"(.*)" should match against the generated css$/ do |data|
  css = CustomizationWriter.new(assigns(:current_user) || @current_user).prepare_template
  css.match(data).should_not == nil
end

Then /^"(.*)" should not match against the generated css$/ do |data|
  css = CustomizationWriter.new(assigns(:user) || @current_user).prepare_template
  css.match(data).should == nil
end

Then /^"(.*)" should not match against the HTML$/ do |data|
  response.body.match(data).should == nil
end

Then /^I should see a follow button$/ do
  response.body.should have_tag("input[class='pill_button']")
end

Then /^I should see a "(.*)" button$/ do |text|
  response.body.should have_tag("input[class='pill_button'][value='#{text}']")
end

Then /^I should see a "(.*)" heading$/ do |text|
  response.body.should have_tag("h1, h2, h3, h4, h5, h6", :text => text)
end

Then /^I should not see a "(.*)" heading$/ do |text|
  response.body.should_not have_tag("h1, h2, h3, h4, h5, h6", :text => text)
end

Then /^I should see an option named "(.*)" for "(.*)"$/ do |option_name, field_name|
  response.body.should have_selector("select[name='#{field_name}']") { |select|
    select.inner_html.should have_selector("option") { |option|
      option.inner_text.should include(option_name)
    }
  }
end

Then /^I should see the option "(.*)" selected for field "(.*)"$/ do |option_name, field_name|
  response.body.should have_selector("select[name='#{field_name}']") { |select|
    select.inner_html.should have_selector("option[selected]") { |option|
      option.inner_text.should include(option_name)
    }
  }
end

Then /^I should see the option "(.*)" as the first item for field "(.*)"$/ do |option_name, field_name|
  response.body.should have_selector("select[name='#{field_name}']") { |select|
    select.inner_html.should have_selector("option:nth-child(1)") { |option|
      option.inner_text.should include(option_name)
    }
  }
end

Then /^I should see the text field "(.*)" filled with "(.*)"$/ do |field_name, expected_value|
  response.body.should have_selector("input[type='text'][name='#{field_name}'][value='#{expected_value}']")
end

Then /^the status should be (.+)$/ do |text|
  response.status.should =~ /#{text}/m
end

Then /^the checkbox field named "(.*)" should be checked$/ do |field_name|
  field_named(field_name).should be_checked
end

Then /^the "(.*)" checkbox should be checked$/ do |label|
  field_labeled(label).should be_checked
end

Then /^ the "(.*)" radio button should be chosen$/ do |label|
  field_labeled(label).should be_chosen
end

Then /^I should see a radio button labeled "(.*)"$/ do |label|
  field_labeled(label).should be_a_kind_of(Webrat::RadioField)
end

Then /^I should see "(.*)" stripped$/ do |text|
  current_dom.text.gsub(/\s+/,' ').should include_text(text.gsub(/\s+/,' '))
end


Then /^I should see a "(.*)" label$/ do |label|
  response.should have_tag('label', label)
end

When /^I omit "(.*)"/ do |label|
  fill_in(label, :with => "")
end

Then /^I should see an image with the source "(.*)"$/ do |src|
  response.should have_tag('img[src*=?]', src)
end

Then /^I should see an? (\w+) avatar for "(.*)"$/ do |type, name|
  response.should have_tag("img.avatar.#{type}[title=?]", name)
end

Then /^raise the body$/ do
  raise response.body
end

Then /^raise the current url$/ do
  raise URI.parse(current_url).path
end

Then /^I should see form errors$/ do
  response.should contain(I18n.t("activerecord.errors.template.body"))
end

When /^I fill file field "([^\"]*)" with "([^\"]*)" and format "([^\"]*)"$/ do |field, value, format|
  format = "image/#{format}" if ["jpg","jpeg","gif","png"].include?(format)
  format = "application/#{format}" if ["ms-word","msword","pdf","flv"].include?(format)
  attach_file(field, File.join(Rails.root, APP_CONFIG[:support_files] , value), "#{format}")
end
