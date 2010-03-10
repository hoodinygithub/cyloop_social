Before do
  Given 'there is a city called "Miami" in "Florida" in "United States"'
  Given 'there is a country named "United States" with code "US"'
  Given 'there is a site named "Cyloop" whose locale is "en"'
  Given 'there is a site named "MSN Mexico" whose locale is "es"'
  Given 'there is a site named "MSN Brazil" whose locale is "pt_BR"'
  Given 'the current site is "Cyloop"'
end

Given /^there is a site named "(.*)" whose locale is "(.*)"$/ do |site_name, locale|
  @site = Site.find_or_create_by_name_and_default_locale_and_code(site_name, locale.to_sym, site_name.downcase.gsub(' ', ''))
end

Given /^the current locale is "(.*)"$/ do |locale_code|
  locale = locale_code.to_sym
  @current_site.stub!(:default_locale).and_return(locale)
  I18n.default_locale = locale
  I18n.locale = locale
end

Given /^the current site is "(.*)"$/ do |site_name|
  Application::Sites::CURRENT_SITE = Site.find_or_create_by_name(site_name) unless Application::Sites::CURRENT_SITE.name == site_name# || defined?(Application::Sites::CURRENT_SITE)
  ENV['SITE'] = site_name
  @current_site = Application::Sites::CURRENT_SITE
end

Given /^there is a country named "(.*)" with code "(.*)"$/ do |country_name, country_code|
  @country = Country.find_or_create_by_name_and_code :name => country_name, :code => country_code
end

Given /^the default locale for site "(.*)" is "(.*)"$/ do |site_name, locale_name|
  site = Site.find_by_name(site_name)
  site.default_locale = locale_name.to_sym
  site.save!
  I18n.locale = I18n.default_locale = ApplicationController.current_site.default_locale
  I18n.backend.send(:init_translations)
  @current_site = ApplicationController.current_site
end

Then /^my entry point should be "(.*)"$/ do |entry_point_name|
  @current_user.entry_point.should == Site.find_by_name(entry_point_name)
end

Then /^the current locale should be "(.*)"$/ do |locale|
  I18n.locale.should == locale.to_sym
end
