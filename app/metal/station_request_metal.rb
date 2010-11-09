# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class StationRequestMetal
  def self.call(env)
    request     = Rack::Request.new(env)
    session     = env['rack.session']
    request_uri = request.referrer
    remote_ip   = env['REMOTE_ADDR']
    params      = request.params

    station_request    = /^\/activity\/stationrequest\/(\d+)\/(\d+)\/(\d+)$/

    if env["PATH_INFO"] =~ station_request
      options = Hash.new
      options.merge!(params)
      options[:remote_ip] = env.has_key?('HTTP_TRUE_CLIENT_IP') ? env['HTTP_TRUE_CLIENT_IP'] : remote_ip
      options[:user_id] = session[:user_id] || nil
      options[:timestamp] = Time.now.to_i
      # Hostname is not reliable enough.
      # options[:site_id] = env['HTTP_HOST']
      options[:site_id] = ENV['SITE']

      options.merge!({:station_id => $1, :player_id => $2, :song_count => $3, :source => request_uri})

      Resque.enqueue(RecordStationRequestJob, options)
      [200, {"Content-Type" => "text/html"}, ""]
    else
      [404, {"Content-Type" => "text/html"}, "Not Found"]
    end
  end
end
