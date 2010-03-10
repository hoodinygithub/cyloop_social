module SimpleNotification
  class Mac
    @last_test_failed = false

    class << self
      
      def notify(title, msg, img)
        system "growlnotify -n autotest --image #{img} -p 0 -m '#{msg}' -t #{title}"
      end
      
    end
  end
end
