module AdsHelper
  def ad_options(id, options={})  
    options = options.symbolize_keys
    @ad_options = {}

    # loc
    # Represents the current page where the code is invoked
    @ad_options[:loc] = URI.escape(request.path_info, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  
    # v_lang
    # Represents the sites language; required
    # Value: [language code] ex. “es”, “en”, “pt”, etc.
    @ad_options[:v_lang] = current_site.default_locale.to_s
  
    # v_profiletype
    # Represents the type of profile being viewed
    # Values: “ARTIST” or “USER” or “” for other non-profile type pages
    @ad_options[:v_profiletype] = ad_profile_type.upcase
  
    # v_folder
    # Represents the profiles URL
    # Values: [foldername/url] ex. “coldplay” or “suezieq71”
    @ad_options[:v_folder] = if params[:controller] == "custom_artists"
      params[:action]
    else
      params.fetch(:slug, '')
    end
  
    # v_country
    # Represents the Users country; required only for logged in users
    # Values: [country] ex. “US”, “MX”, “BR”, etc.
    @ad_options[:v_country] = current_user.country.code rescue ''
  
    # v_region
    # Represents the Consumers region/state; required only for logged in users 
    # Values: [region] ex. “FL”, “CA”, “TX”, etc.
    @ad_options[:v_region] = current_user.city.region.code rescue ''    
  
    # v_city
    # Represents the Consumers city; required only for logged in users
    # Values: [city] ex. “Los Angeles”, “Miami”, etc.
    @ad_options[:v_city] = current_user.city.name rescue ''        
  
    # v_age
    # Represents the Consumers age; required only for logged in users
    # Values: [age] ex. “16”, “18”, etc.
    @ad_options[:v_age] = current_user.age rescue ''
  
    # v_gender
    # Represents the Consumers gender; required only for logged in users
    # Values: [gender] ex. “male”, “female”, etc.
    @ad_options[:v_gender] = current_user.gender rescue ''    

  
    # v_artistlabel
    # Represents the artists partner_label; required on all artist profiles
    # Values: ex. “sony”, “warner”, “emi”
    # v_artistgenre
    # Represents the artists genre; required on all artist profiles 
    # Values: [genre] ex. “rock”, “pop”
    @ad_options.merge!(ad_artist_info||{})
  
    # v_songlabel
    # Represents the partner_label of the song; required only for every location where there is song play (OD or Radio player)
    # Values: [labelname] ex. “EMI”, “Sony” **Can be different from Artist’s label
    @ad_options[:v_songlabel] = params.fetch(:song_label, '')
  
    # v_songgenre
    # Represents the genre of the song; required only for every location where there is song play (OD or Radio player)
    # Values: [genre] ex. “rock”, “pop”, etc.  **Can be different from Artist’s genre
    @ad_options[:v_songgenre] = params.fetch(:song_genre, '')
    
    # Random Value
    @ad_options[:cb] = rand(99999999999)
        
    # Get the right Zone Id
    @ad_options[:zoneid] = params.fetch(:cZoneId, ad_get_zone_id(id))
    
    # v_promocode
    # Represent the promotion code of the active campaign
    # Values: [promo] ex. "hoodiny", "taringa"
    @ad_options[:v_promocode] = params.fetch(:cPromoCode, '')
    
    # Use iframe
    @ad_options[:iframe] = ["artist", "radio"].include?(ad_zone(id))
    
    # When a override is needed
    @ad_options.merge!(options)
  end

  def ad_size(id)
    size = if id == 'square_banner'
      "300x250"
    elsif id == "pixel_banner"
      "1x1"
    elsif id == "messenger"
      "234x60"
    else
      "728x90"
    end
  end
  
  def ad_profile_type
    if params[:controller] == "custom_artists"
      @profile_account.type.to_s
    elsif (params[:slug] || request.path_info.index("/my/") == 0) && !profile_account.nil?      
      profile_account.type.to_s
    else
      ""
    end
  end
  
  def ad_zone(id)
    profile = ad_profile_type
    zone = if action_name == "home"
      "home"
    elsif controller_name == "radio" and action_name == "mix_index" || controller_name == "playlists"
      "mixer"
    elsif controller_name == "radio"
      "radio"
    elsif controller_name == "messenger_radio" || id == "messenger"
      "messenger"      
    elsif !profile.empty?
      profile.downcase
    else
      "other"
    end    
  end
  
  def ad_artist_info
    if profile_account.is_a?(Artist)
      options = {
        :v_artistgenre => profile_account.genre_name.to_s,
        :v_artistlabel => profile_account.label_name.to_s
      }
    end
  end

  def ad_get_zone_id(id)
    # current_site_code = Rails.env.production? && site_code.to_sym || :staging
    current_site_code = site_code.to_sym
    zones = ADS_ZONES[current_site_code] || ADS_ZONES[:staging]
    zones["#{ad_zone(id)}_#{ad_size(id)}"]
  end

  def banner_ad(id, options={})
    return nil if ["top_songs_banner", "pixel_banner", "top_artists_banner"].include?(id)
    
    options       = options.symbolize_keys    
    options       = ad_options(id, options)
    url_options   = options.to_a.map{|e| e.join("=")}.join("&")
    width, height = ad_size(id).split("x")
    base = "openx.cyloop.com/www/delivery/"
    
    # if options[:iframe]
      image = image_tag("http://#{base}avw.php?#{url_options}", :border => 0)
      link_inside_iframe = link_to(image, "http://#{base}ck.php?#{url_options}", :target => '_blank')
      iframe = content_tag(:iframe, link_inside_iframe, {
        :id => id, 
        :src => "http://#{base}afr.php?#{url_options}", 
        :width => width, 
        :height => height, 
        :framespacing => '0', 
        :frameborder => 'no', 
        :scrolling => 'no',
        :border => '0'
      })
      styles = options[:no_padding_and_margin] && "<style>*{margin:0;padding:0}</style>" || ""
      "#{styles}#{iframe}"
    # else
    #   html = <<-ADS
    #   <!--/* OpenX Javascript Tag v2.8.2 */-->
    #   <script type='text/javascript'><!--//<![CDATA[
    #      var m3_u = (location.protocol=='https:'?'https://#{base}ajs.php':'http://#{base}ajs.php');
    #      if (!document.MAX_used) document.MAX_used = ',';
    #      document.write ("<scr"+"ipt type='text/javascript' src='"+m3_u);
    #      document.write ("?#{url_options}");
    #      if (document.MAX_used != ',') document.write ("&amp;exclude=" + document.MAX_used);
    #      document.write (document.charset ? '&amp;charset='+document.charset : (document.characterSet ? '&amp;charset='+document.characterSet : ''));
    #      if (document.referrer) document.write ("&amp;referer=" + escape(document.referrer));
    #      if (document.context) document.write ("&context=" + escape(document.context));
    #      if (document.mmm_fo) document.write ("&amp;mmm_fo=1");
    #      document.write ("'><\/scr"+"ipt>");
    #   //]]>--></script>      
    #   ADS
    # end
  end  
end

