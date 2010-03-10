require 'rubygems'
require 'daemons'
require 'timeout'

module Daemons

  class ApplicationGroup

    # Specify :force_kill_wait => (seconds to wait) and this method will
    # block until the process is dead.  It first sends a TERM signal, then
    # a KILL signal (-9) if the process hasn't died after the wait time.
    # Note: The force argument is from the original daemons implementation.
    def stop_all(force = false)
      @monitor.stop if @monitor
      
      failed_to_kill = false
      debug = options[:debug]
      wait = options[:force_kill_wait].to_i
      pids = unix_pids
      if wait > 0 && pids.size > 0
        puts "[daemons_ext]: Killing #{app_name} with force after #{wait} secs."
        STDOUT.flush

        # Send term first, don't delete PID files.
        pids.each {|pid| Process.kill('TERM', pid) rescue Errno::ESRCH}

        begin
          Timeout::timeout(wait) {block_on_pids(wait, debug, options[:sleepy_time] || 1)}
        rescue Timeout::Error
          puts "[daemons_ext]: Time is up! Forcefully killing #{unix_pids.size} #{app_name}(s)..."
          STDOUT.flush
          unix_pids.each {|pid| `kill -9 #{pid}`}
          begin
            # Give it an extra 30 seconds to kill -9
            Timeout::timeout(30) {block_on_pids(wait, debug, options[:sleepy_time] || 1)}
          rescue Timeout::Error
            failed_to_kill = true
            puts "[daemons_ext]: #{unix_pids} #{app_name}(s) won't die! Giving up."
            STDOUT.flush
          end
        ensure
          # Delete Pidfiles
          @applications.each {|a| a.zap!}
        end

        puts "[daemons_ext]: All #{app_name}s dead." unless failed_to_kill
        STDOUT.flush
      else
        @applications.each {|a| 
          if force
            begin; a.stop; rescue ::Exception; end
          else
            a.stop
          end
        }
      end
    end
    
    private

    # Block until all unix_pids are gone (should be wrapped in a timeout)
    def block_on_pids(wait, debug, sleepy_time = 1)
      started_at = Time.now
      num_pids = unix_pids.size
      while num_pids > 0
        time_left = wait - (Time.now - started_at)
        puts "[daemons_ext]: Waiting #{time_left.round} secs on " +
              "#{num_pids} #{app_name}(s)..."
        unix_pids.each {|pid| puts "\t#{pid}"} if debug
        STDOUT.flush
        sleep sleepy_time
        num_pids = unix_pids.size
      end 
    end

    # Find UNIX pids based on app_name.  CAUTION: This has only been tested on
    # Mac OS X and CentOS.
    def unix_pids
      pids = []
      x = `ps auxw | grep -v grep | awk '{print $2, $11}' | grep #{app_name}`
      if x && x.chomp!
        processes = x.split(/\n/).compact
        processes = processes.delete_if do |p|
          pid, name = p.split(/\s/)
          # We want to make sure that the first part of the process name matches
          # so that app_name matches app_name_22
          app_name != name[0..(app_name.length - 1)]
        end
        pids = processes.map {|p| p.split(/\s/)[0].to_i}
      end

      pids
    end

  end

  class Application

    def initialize(group, add_options = {}, pid = nil)
      @group = group
      @options = group.options.dup
      @options.update(add_options)
      
      @dir_mode = @dir = @script = nil
      
      unless @pid = pid
        if @options[:no_pidfiles]
          @pid = PidMem.new
        elsif dir = pidfile_dir
          @pid = PidFile.new(dir, @group.app_name, @group.multiple)
        else
          @pid = PidMem.new
        end
      end
    end

  end

end
