# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class ListenMetal
  def self.call(env)
    request   = Rack::Request.new(env)
    request_uri = request.referrer
    session   = env['rack.session']
    remote_ip = env['REMOTE_ADDR']
    params    = request.params

    radio_listen = /^\/activity\/listen\/radio\/(\w+)\/(\d+)\/(\d+)\/(\d+)\/(\d+)$/
    on_demand    = /^\/activity\/listen\/ondemand\/(\w+)\/(\d+)\/(\d+)\/(\d+)$/

    if (env["PATH_INFO"] =~ radio_listen || env["PATH_INFO"] =~ on_demand)
      options = Hash.new
      options.merge!(params)
      options[:remote_ip] = env.has_key?('HTTP_TRUE_CLIENT_IP') ? env['HTTP_TRUE_CLIENT_IP'] : remote_ip
      options[:user_id] = session[:user_id] || nil
      options[:timestamp] = Time.now.to_i
      options[:site_id] = env['HTTP_HOST']

      if env["PATH_INFO"] =~ radio_listen
        # RADIO = 1
        options.merge!({:type => $1, :song_id => $2, :duration => $3, :station_id => $4, :player_id => $5, :license_id => 1, :source => request_uri})
      elsif env["PATH_INFO"] =~ on_demand
        # ON-DEMAND = 2
        options.merge!({:type => $1, :song_id => $2, :duration => $3, :player_id => $4, :license_id => 2, :source => request_uri})
      end

      Resque.enqueue(RecordListenJob, options)
      Rails.logger.info "Enqued: RecordListenJob, options: #{options.inspect}"
      [200, {"Content-Type" => "text/html"}, ""]
    else
      [404, {"Content-Type" => "text/html"}, "Not Found"]
    end
  end
end
