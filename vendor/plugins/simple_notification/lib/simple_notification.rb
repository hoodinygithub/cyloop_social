$:.unshift(File.dirname(__FILE__))

module SimpleNotification
  
  class Config

    class << self
      attr_reader :images_directory
      attr_accessor :success_image, :fail_image, :pending_image, :expiration_in_seconds

      def images_directory=(path)
        @images_directory = File.expand_path(path)

        @success_image = "#{@images_directory}/pass.png"
        @fail_image    = "#{@images_directory}/fail.png"
        @pending_image = "#{@images_directory}/pending.png"
      end
    end

    self.images_directory = "#{File.dirname(__FILE__)}/../images/"

    self.expiration_in_seconds = 3

  end

  class << self
    def notify(title, msg, img = Config.success_image)
      return nil if Rails.env != 'development' && ENV[ 'SIMPLE_NOTIFICATION' ] != 'true'

      case RUBY_PLATFORM
      when /linux/
        Linux.notify(title, msg, img)
      when /darwin/
        Mac.notify(title, msg, img)
      when /cygwin/
        Cygwin.notify(title, msg, img)
      when /mswin/
        Windows.notify(title, msg, img)
      end
    end
    
  end
end

%w{ linux mac windows cygwin}.each { |x| require "simple_notification/#{x}" }

if RUBY_PLATFORM == 'java'
  require 'java'
  SimpleNotification.const_set :RUBY_PLATFORM, java.lang.System.getProperty('os.name').downcase
end
