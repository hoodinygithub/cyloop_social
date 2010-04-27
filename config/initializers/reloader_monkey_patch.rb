if Rails.env.development?
  module ActionController
    class Reloader
      def self.run(lock = @@default_lock)
        lock.lock
        begin
          Dispatcher.reload_application
          status, headers, body = yield
          lock.unlock
          [status, headers, body]
        rescue Exception
          lock.unlock
          raise
        end
      end
    end
  end
end