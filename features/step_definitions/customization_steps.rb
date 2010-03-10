Given 'I have really bad colors' do
  Given 'I am on my customizations page'
  When 'I fill in "user[color_header_bg]" with "123456"'
  When 'I fill in "user[color_links]" with "654321"'
  When 'I fill in "user[color_main_font]" with "ABCDEF"'
  When 'I fill in "user[color_bg]" with "FEDCBA"'
  When 'I click "Save"'
end

Then 'I should have the default colors' do
  When 'I go to my customizations page'
  Then 'I should see the text field "user[color_header_bg]" filled with "025D8C"'
  Then 'I should see the text field "user[color_main_font]" filled with "27343C"'
  Then 'I should see the text field "user[color_links]" filled with "025D8C"'
  Then 'I should see the text field "user[color_bg]" filled with "ECECEC"'
end