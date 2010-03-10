# Allow the metal piece to run in isolation
# require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class PersonalizeJavascript
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/logged_in.js/
      request   = Rack::Request.new(env)
      session   = env['rack.session']
      host_port = (request.port.to_s == "80") ? "#{request.host}" : "#{request.host}:#{request.port}"
      if session && session[:user_id]
        params    = request.params
        logout_url = params['logout_url'] ? "<a href='#{params['logout_url']}'>#{I18n.t("sessions.destroy.sign_out").strip}<\/a>" : ""
        I18n.default_locale = params['lang'].to_sym rescue :en
        js = <<-END
        jQuery(document).ready(function($){  
          $('#nav_aux').html("#{logout_url}");
          $('#nav_main ul.nav_tabs').prepend("<li class='tab dashboard'><a href='/my/dashboard'>#{I18n.t("navigation.dashboard").strip}</a></li>");
});
        END
        [200, {"Content-Type" => "text/javascript; charset=utf-8", "Cache-Control" => "no-cache", "Expires" => "-1"}, [js.gsub("\n", ' ')]]
      else
        [200, {"Content-Type" => "text/html", "Cache-Control" => "no-cache", "Expires" => "-1"}, ['']]
      end
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
