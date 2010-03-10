Given /^the countries:$/ do |table|
  table.hashes.each do |hash|
    c = Country.find_or_create_by_name_and_code(:name => hash['name'], :code => hash['code'])
  end
end

Given /^the current country is "(.*?)"$/ do |country|
  c = Country.find_by_code country
  controller.stub!(:current_country).and_return(c)
end
