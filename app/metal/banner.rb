# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Banner  
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/pages\/banner_ads/
      request  = Rack::Request.new(env)
      b = binding
      @options = request.params
      @query_string = env['QUERY_STRING'].gsub(/\--/,'')
      banner = ERB.new(banner_template)
      
      [200, {"Content-Type" => "text/html"}, [banner.result(b)]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
  
  def self.t(text)
    ActionView::Base.full_sanitizer.sanitize(text)
  end
  
  def self.banner_template
    @banner_template ||= <<-EOF
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
    <html xmlns:java="http://xml.apache.org/xslt/java" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <style type="text/css">
    html, body {
      margin:0px;
      padding:0px;
      overflow:hidden;
      border:none;
    }
    </style>

    <script type="text/javascript">
      // ValueParameters
      ValueTargetCurrent = true;
      ValueHost = "<%=t @options['host'] %>";
      ValueLoaded = false;
      ValueID = "pagebuster";
      ValueVersion = "1.2";
      ValueBannerType = "std";
      var ValueWidths_Heights = new Array("<%=t @options['width'] %>x<%=t @options['height'] %>");

      ValueNoText = 1;
      var ValueCategory = "<%=t @options['valuecategory'] %>";

      var keys = "<%=t @query_string %>";

      var ValueKeyCodes = new Array(keys);

      ValueBannerSizeOrder =  "listed";

      //Added for compatibility with MSN
      ValueIFrame = 1;
    </script>

    <script type="text/javascript" src="http://ads.hood.valueclick.net/jsmaster"></script>
    <script type="text/javascript">
      try 
      {
        var Num = Math.floor (Math.random()*1000000);
        if (ValueLoaded) ValueShowAd();
      } catch(e)
      {

      }
    </script>

  <script type="text/javascript">
    try {
      var body=document.getElementsByTagName("body");
      body[0].setAttribute("mediaplexHref", "http://ads.hood.valueclick.net/redirect?<%=t @query_string %>&t=std&b=indexpage&noscript=1&msizes=<%=t @options['width'] %>x<%=t @options['height'] %>&bso=listed");
      body[0].setAttribute("mediaplexImg","http://ads.hood.valueclick.net/cycle?<%=t @query_string %>&t=std&b=indexpage&noscript=1&msizes=<%=t @options['width'] %>x<%=t @options['height'] %>&bso=listed");      
    } catch(e) {
      
    }
  </script>

    <noscript>
      <a target="_top" href="http://ads.hood.valueclick.net/redirect?<%=t @query_string %>&t=std&b=indexpage&noscript=1&msizes=<%=t @options['width'] %>x<%=t @options['height'] %>&bso=listed"><img alt="Click here to visit our sponsor" border="0" src="http://ads.hood.valueclick.net/cycle?<%=t @query_string %>&t=std&b=indexpage&noscript=1&msizes=<%=t @options['width'] %>x<%=t @options['height'] %>&bso=listed"></a>
    </noscript>

    </head>

    <body id="mpBody"></body>

    </html>
    EOF
  end
end
