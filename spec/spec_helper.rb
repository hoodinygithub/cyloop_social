# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  config.include AuthenticatedTestHelper
  config.include JobsHelper
  config.include MsnHelper
  config.include SiteHelper
  config.include RecEngineHelper
  config.global_fixtures = :all
  config.mock_with :mocha
end

Spec::Matchers.define :expire_fragment do |fragment, options|
  match do |controller|
    controller.cache_store.should_receive(:delete).with("views/#{fragment}", options)
  end
end
