module Application

  module VisitsRecorder

    module ClassMethods

      def record_visits( *args )
        after_filter :record_visit, *args
      end

    end

    def self.included( base )
      base.extend( Application::VisitsRecorder::ClassMethods )
    end

    def record_visit
      begin
        tracker_payload = {
          :owner_id => @profile_account.id,
          :visitor_id => (current_user.nil?)? nil : current_user.id,
          :site_id => current_site.id,
          :visitor_ip_address => remote_ip,
          :timestamp => Time.now.to_i
        }
        Resque.enqueue(ProfileVisitJob, tracker_payload)
      rescue
        Rails.logger.error("*** Could not record visit! payload: #{tracker_payload}") and return true
      end
    end

  end

end