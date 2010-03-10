class Cyloop
  class Deprecated
    class ActivityFeed

      def self.clear!
        raise "Refusing to delete user activity feed files in production." if Rails.env.production?
        FileUtils.rm_rf(File.join(ActivityWriter::PATH, 'activity_feeds'))
      end

      def initialize(user)
        @user = user
      end

      def lines(limit = nil, show_friends_activities = false)
        result = read_file(@user.id, 'listen', (limit.nil?) ? 60 : limit).collect {|line| line_wrapper(line)}
        if show_friends_activities && @user.user?
          @user.followees.each do |f|
            result += read_file(f.id, 'listen', 15).collect {|line| line_wrapper(line)} unless f.artist?
          end
          result.sort! {|a,b| a["timestamp"] <=> b["timestamp"]}
        end
        result.reverse!
        result = result.slice(0..(limit.to_i - 1)) unless limit.nil?
        return result.compact
      end

      def self.collect_lines(lines)
        lines.collect { |line| (ActivityProxy::Reader.new(line).yason rescue nil) }.compact
      end

      protected

      def line_wrapper(line)
        l = ActivityProxy::Reader.new(line)
        l.valid_yason
      end

      def read_file(user_id, type = 'listen', lines = 15)
        # File.open_locked(File.join(ActivityWriter::PATH,'activity_feeds', PartitionedPath.path_for(user_id), "#{type}_activity")) do |f|
        #   f.readlines()
        # end

        # TODO
        # Figure out / Test file locking
        path = File.join(ActivityWriter::PATH,'activity_feeds', PartitionedPath.path_for(user_id), "#{type}_activity")
        `tail -n #{lines} #{path}`    
      rescue #Errno::ENOENT
        Rails.logger.info "No activity file found for user: #{@user}"
        [] # user didn't have activity
      end

    end
  end
end