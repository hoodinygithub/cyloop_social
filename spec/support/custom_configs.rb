ENV["RAILS_ENV"] ||= "test"
ENV['SITE'] ||= 'MSN Canada EN'

require 'remarkable_rails'
require 'factory_girl'
require 'factory_girl/syntax/generate'

module Spec::Rails::Example
  class IntegrationExampleGroup < ActionController::IntegrationTest
    def initialize(defined_description, options={}, &implementation)
      defined_description.instance_eval do
        def to_s
          self
        end
      end
      super(defined_description)
    end
    Spec::Example::ExampleGroupFactory.register(:integration, self)
  end
end