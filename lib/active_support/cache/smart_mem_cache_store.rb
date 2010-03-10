module ActiveSupport
  module Cache
    class SmartMemCacheStore < MemCacheStore
 
      alias_method :orig_read, :read
      alias_method :orig_write, :write
 
      def read(key, options = nil)
        lock_expires_in = options.delete(:lock_expires_in) if !options.nil?
        lock_expires_in ||= 10
 
        response = orig_read(key, options)
        return nil if response.nil?
 
        data, expires_at = response
        if Time.now > expires_at && !exist?("lock_#{key}")
          orig_write("lock_#{key}", true, :expires_in => lock_expires_in)
          return nil
        else
          data
        end
      end
 
      def write(key, value, options = nil)
        expires_delta = options.delete(:expires_delta) if options && options.has_key?(:expires_delta)
        expires_delta ||= 300
 
        expires_at = Time.now + expires_delta
        package = [value, expires_at]
        orig_write(key, package, options)
        delete("lock_#{key}")
      end
    end
  end
end