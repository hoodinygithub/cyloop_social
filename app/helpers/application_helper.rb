module ApplicationHelper

  include PopupHelper

  def sort_link_to(type, options = {})
    type = type.to_s if type.is_a? Symbol

    raise ArgumentError unless type

    url = request.request_uri.split('?').first
    url << "?page=#{params[:page]}" if params.fetch(:page, nil)
    url << (url.include?('?') ? '&' : '?')
    url << "sort_by=#{type}"
    url = url.downcase

    if @sort_type.to_s == type
      options[:class] = 'active'
    end

    link_to t("sort.#{type}"), url, options
  end

  def following_page?
    params[:controller] == 'followees'
  end

  def profile_owner?
    current_user == profile_account
  end

  def profile_user?
    profile_account.kind_of? User
  end
  
  def profile_artist?
    profile_account.kind_of? Artist
  end

  def main_content(content)
    if params[:controller] == 'pages'
      if params[:action] != 'home'
        content_tag(:div, content_tag(:div, content_tag(:div, content, :id => 'pages_internal'), :id => 'internal_content'), :id => 'pages')
      else
        content
      end
    else
      content_tag(:div, content, :id => 'internal_content')
    end
  end

  def special_button(type, button_label, options = {})
    options.merge!({
      :class => "#{options[:class]} #{type}",
      :onclick => "#{options[:onclick]}; return false;"
    })

    if options[:href]
      options.delete(:onclick)
    else
      options[:href] = '#' unless options[:href]
    end
  
    if options[:width]
      span_label = content_tag(:span, button_label, :style => "width: #{options.delete(:width)}")
    else
      span_label = content_tag(:span, button_label)
    end

    button = content_tag(:span, span_label)
    link_to button, options[:href], options
  end

  def blue_button(button_label, options = {})
    special_button(:blue_button, button_label, options)
  end

  def green_button(button_label, options = {})
    special_button(:green_button, button_label, options)
  end
  
  def yellow_button(button_label, options = {})
    special_button(:yellow_button, button_label, options)
  end
  

  def station_contains(item, limit=3)
    links = []
    station_artists = item.includes(limit)

    station_artists.each do |station_artist|      
      links << link_to(station_artist.artist.name, artist_path(station_artist.artist))
    end

    "#{t('basics.contains')}: #{links.join(", ")}..."
  end

  def render_flash_messages
    if flash[:success]
      message = flash[:success]
      stylesheet_class = 'confirmation_message'
    elsif flash[:error]
      message = flash[:error]
      stylesheet_class = 'error_message'
    end

    flash[:error] = flash[:success] = nil

    html = ""
    if defined? message and !message.blank?
      html = content_tag(:div, content_tag(:div, message, :class => stylesheet_class), :class => 'message')
    end

    html
  end

  def four_thumbs_to(station, options = {})  
    station      = station.try(:playable)
    station_link = radio_path(:station_id => station.station.id)
    
    station_images_with_links = []
  
    # TODO: Handle this issue with DB showing a default image
    if options[:type].nil?
      station.includes(4).each do |artist|
        station_images_with_links << link_to(image_tag(AvatarsHelper.avatar_path(artist.album, :small), :class => 'avatar_four_thumbs'), station_link)
      end
      station_images_with_links << content_tag(:br, "&nbsp;", :class => 'clearer') if options[:clearer]
      html = content_tag(:div, station_images_with_links, :class => "four_thumbs #{options[:class]}")

    elsif options[:type] == :small
      station.includes(4).each do |artist|
        station_images_with_links << link_to(image_tag(AvatarsHelper.avatar_path(artist.album, :small), :class => 'avatar_four_thumbs_small'), station_link)
      end
      station_images_with_links << content_tag(:br, "&nbsp;", :class => 'clearer') if options[:clearer]
      html = content_tag(:div, station_images_with_links, :class => "four_thumbs_small #{options[:class]}")

    elsif options[:type] == :medium
      station.includes(4).each do |artist|
        station_images_with_links << link_to(image_tag(AvatarsHelper.avatar_path(artist.album, :small), :class => 'avatar_four_thumbs_medium'), station_link)
      end
      station_images_with_links << content_tag(:br, "&nbsp;", :class => 'clearer') if options[:clearer]
      html = content_tag(:div, station_images_with_links, :class => "four_thumbs #{options[:class]}")

    elsif options[:type] == :big
      station.includes(4).each do |artist|
        station_images_with_links << link_to(image_tag(AvatarsHelper.avatar_path(artist.album, :small), :class => 'avatar_four_thumbs_big'), station_link)
      end      
      station_images_with_links << content_tag(:br, "&nbsp;", :class => 'clearer') if options[:clearer]
      html = content_tag(:div, station_images_with_links, :class => "four_thumbs_big #{options[:class]}")
    end
  end


  def nav_aux_login_url
    if params.fetch(:controller) == "pages" && params.fetch(:action) == "home"
      my_dashboard_path
    else
      request.request_uri
    end
  end

  def body_classes(aditional_classes=nil)
    all_classes = [
      "#{site_code}_#{controller.action_name}",
      "#{controller.controller_name}_#{controller.action_name}",
      controller.controller_name,
      controller.action_name,
      I18n.locale,
      site_code
    ]
    unless aditional_classes.nil?
      all_classes << " #{aditional_classes}"
    end
    all_classes.join(" ")
  end

  def application_html_attrs
    if is_msn_messenger_enabled?
      html_attrs.merge( 'xmlns:msgr' => 'http://messenger.live.com/2009/ui-tags', 'xml:lang' => current_site.default_locale.to_s.downcase.split('_').join('-') )
    else
      html_attrs
    end
  end

  def twitter_date_activity(date)
    date = Time.at(date.to_i)
    output = date.to_date.to_s(:default)
    output << " | #{date.strftime('%I:%M%p')}"
  end

  def generic_URL_regexp
    @generic_URL_regexp ||= Regexp.new( '(^|[\n ])([\w]+?://[\w]+[^ \"\n\r\t<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
  end
  def starts_with_www_regexp
    @starts_with_www_regexp ||= Regexp.new( '(^|[\n ])((www)\.[^ \"\t\n\r<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
  end
  def starts_with_ftp_regexp
    @starts_with_ftp_regexp ||= Regexp.new( '(^|[\n ])((ftp)\.[^ \"\t\n\r<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
  end
  def email_regexp
    @email_regexp ||= Regexp.new( '(^|[\n ])([a-z0-9&\-_\.]+?)@([\w\-]+\.([\w\-\.]+\.)*[\w]+)', Regexp::IGNORECASE )
  end
  def linkify( text )
    s = text.to_s
    s.gsub!(generic_URL_regexp, '\1<a target="_blank" rel="nofollow" href="\2">\2</a>' )
    s.gsub!(starts_with_www_regexp, '\1<a target="_blank" rel="nofollow" href="http://\2">\2</a>' )
    s.gsub!(starts_with_ftp_regexp, '\1<a target="_blank" rel="nofollow" href="ftp://\2">\2</a>' )
    s.gsub!(email_regexp, '\1<a target="_blank" rel="nofollow" href="mailto:\2@\3">\2@\3</a>' )
    s
  end

  def gatracker_id
    case current_site.name
    when "MSN Mexico"
      "UA-410780-31"
    when "MSN Brazil"
      "UA-410780-29"
    when "MSN Latam"
      "UA-410780-32"
    when "MSN US Latin"
      "UA-410780-33"
    when "MSN Canada EN"
      "UA-410780-34"
    when "MSN Canada FR"
      "UA-410780-35"
    when "Cyloop"
      "UA-410780-11"
    when "Cyloop ES"
      "UA-410780-38"
    when "MSN Argentina"
      "UA-410780-46"
    end
  end

  def messenger_player_gatracker_id
    case current_site.name
    when "MSN Brazil"
      "UA-410780-39"
    when "MSN Mexico"
      "UA-410780-40"
    when "MSN Latam"
      "UA-410780-41"
    when "MSN US Latin"
      "UA-410780-42"
    when "MSN Canada EN"
      "UA-410780-43"
    when "MSN Canada FR"
      "UA-410780-44"
    when "MSN Argentina"
      "UA-410780-45"
    end
  end

  def banner_options(id)

    if logged_in?
      if current_user.type.upcase == "USER"
        visitor = "CONSUMER"
      else
        visitor = "ARTIST"
      end
    else
      visitor = "ANON"
    end

    if profile_account == nil
      profile = ""
    else
      if profile_account.type.upcase == "USER"
        profile = "CONSUMER"
      else
        profile = "ARTIST"
      end
    end

    options = {}
    if action_name == "home"
      cat = "38"
    elsif controller_name == "radio"
      cat = "3b"
    elsif controller_name == "demographics"
      cat = "3e"
    elsif controller_name == "artist_recommendations"
      cat = "3e"
    elsif profile == "CONSUMER"
      cat = "3a"
      set_profile = true
    elsif profile == "ARTIST"
      cat = "39"
    elsif controller_name == "users" && action_name == "new"
      cat = "3e"
    elsif controller_name == "searches"
      cat = "3d"
    else
      cat = "3f"
    end


    host_id = if ENV['RAILS_ENV'] =~ /production/
      case current_site.code.to_s
      when 'msnbr'
        "hs0005830"
      when 'msnmx'
        "hs0005801"
      when 'msnlatam'
        "hs0005866"
      when 'msnlatino'
        "hs0005872"
      when 'msncaen'
        "hs0005878"
      when 'msncafr'
        "hs0005877"
      when 'cyloop', 'cyloopes'
        'hs0004280'
      else
        "hs0005803"
      end
    else
      "hs0005803"
    end

    options[:id] = id
    options[:host] = host_id
    options[:valuecategory] = cat
    options[:klang] = current_site.default_locale.to_s
    options[:kviewertype] = visitor
    options[:kprofiletype] = profile unless !set_profile

    if profile == "ARTIST"
      options[:kfolder] = profile_artist.slug
      options[:kartistlabel] = profile_artist.label_name
      options[:kartistgenre] = profile_artist.genre_name
    elsif profile == "CONSUMER" && profile_account.has_custom_profile?
      options[:kfolder] = profile_account.slug
    end

    if logged_in? && current_user.city != nil
      options[:kcountry] = current_user.city.country.code
      options[:kregion] = current_user.city.region.name
      options[:kcity] = current_user.city.name
      options[:kage] = current_user.age unless current_user.born_on == nil
      options[:kgender] = current_user.gender
    end

    if id == "top_banner"
      options[:width] = 728
      options[:height] = 90
    end

    if id == "square_banner"
      options[:width] = 300
      options[:height] = 250
    end

    if id == "pixel_banner"
      options[:width] = 1
      options[:height] = 1
    end

    if id == "top_artists_banner"
      options[:width] = 120
      options[:height] = 30
    end

    if id == "top_songs_banner"
      options[:width] = 120
      options[:height] = 30
    end

    if params[:song_id] != nil
      options["--ksonglabel"] = artist_song(params[:song_id]).artist.label_name.to_s + "--"
      options["--ksonggenre"] = artist_song(params[:song_id]).artist.genre_name.to_s + "--"
    end

    options

  end

  def banner_ad(id)
    options = banner_options(id)
    url_options = options.to_a.map{|e| e.join("=")}.join("&")
    render :partial => 'shared/banner', :locals => {:options => options, :url_options => url_options}
  end

  def full_url(url)
    return url if url =~ /http/
    "http://#{url}"
  end

  # For permalink, use to_param method on model instead (see song.rb)
  # def perma_link(options={})
  #   "#{options[:id]}-#{options[:name].gsub(/[^a-z0-9]+/i, '-')}"
  # end

  def perma_id(link)
    "#{link.split("-")[0]}"
  end

  def profile_public_home?
    profile_user.slug == request.env["REQUEST_URI"].gsub!(/\//,'')
  end

  def navigation_args_main
    args = []
    if page_owner?
      if(profile_public_home?)
        args.push({:home => my_dashboard_path})
      else
        args.push({:dashboard => my_dashboard_path})
      end
    else
      args.push({:home => user_path})
    end
    if profile_type?("Artist")
      args.push({:biography => biography_index_path}, {:music => albums_path})
      args.push({:community => followers_path}, :charts)
    end
    if profile_type?("User")
      args.push(:playlists, {:stations => (page_owner?)? my_stations_path : user_stations_path})
      args.push({:community => following_index_path}, :charts)
    end
    if page_owner?
      args.push({:settings => my_settings_path})
    end
    args
  end

  def filter_args_global
    args = []
    args.push({:all => "#"})
  end

  def filter_args_charts
    args = []
    args.push({:songs => charts_songs_path})
    if profile_type?("Artist")
      args.push({:albums => charts_albums_path})
    end
    if profile_type?("User")
      args.push({:artists => charts_artists_path})
    end
    args
  end

  def filter_args_activity
    args = []
    if page_owner?
      args.push({:songs => my_dashboard_path})
    else
      args.push({:songs => user_path})
    end
    args
  end

  def filter_args_playlists
    args = []
    args.push({:all => playlists_path})
    args
  end

  def filter_args_albums
    args = []
    args.push({:all => albums_path})
    args
  end

  def filter_args_stations
    args = []
    args.push({:stations => :stations})
    args
  end

  def filter_args_followings
    args = []
    args.push({:following => following_index_path})
    args.push({:followers => followers_path})
    args.push({:follow_requests => my_follow_requests_path}) if (profile_user==current_user && current_user.private?)
    args
  end

  def pagination_args
    {
      :previous_label => "« #{t('actions.previous')}",
      :next_label => "#{t('actions.next')} »",
      :renderer => PaginationRenderer
    }
  end

  def msn_home_page_link
    if site_includes(:msnbr, :msnmx, :msnlatam, :msnlatino, :msncaen, :msncafr)
      link_to( 'MSN Music', msn_home_page_link_path )
    else
      ''
    end
  end

  def msn_home_page_link_path
    if site_includes(:msnbr)
      'http://br.msn.com/'
    elsif site_includes(:msnmx)
      'http://prodigy.msn.com/'
    elsif site_includes(:msnlatam)
      'http://latam.msn.com/'
    elsif site_includes(:msnlatino)
      'http://latino.msn.com/'
    elsif site_includes(:msncaen)
      'http://music.ca.msn.cyloop.com/'
    elsif site_includes(:msncafr)
      'http://musique.ca.msn.cyloop.com/'
    elsif site_includes(:msnar)
      'http://ar.msn.com/'
    else
      ''
    end
  end

  def pluralize(count, singular, plural=nil)
    "#{number_with_delimiter(count) || 0} " + ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
  end

  def os_type
    my_os = request.env["HTTP_USER_AGENT"]
    case my_os
    when /Windows NT 6.0/ then "Windows Vista"
    when /Windows NT 5.2/ then "Windows Server 2003/Windows x64"
    when /Windows NT 5.1/ then "Windows XP"
    when /Windows NT 5.0/ then "Windows 2000"
    when /Windows NT 4.0/ then "Windows NT 4"
    when /WindowsXP/      then "Windows XP"
    when /WindowsME/      then "Windows ME"
    when /Windows98/      then "Windows98"
    when /Windows95/      then "Windows95"
    when /Symbian/        then "Symbian OS"
    when /Fedora/         then "Fedora Core"
    when /FreeBSD/        then "FreeBSD"
    when /Red Hat/        then "Red Hat"
    when /SUSE/           then "SUSE"
    when /Mandriva/       then "Mandriva"
    when /Ubuntu/         then "Ubuntu"
    when /Debian/         then "Debian"
    when /ASPLinux/       then "ASP Linux"
    when /ALTLinux/       then "ALT Linux"
    when /PCLinuxOS/      then "PC Linux"
    when /Mandrake/       then "Mandrake"
    when /SunOS/          then "Sun OS"
    when /Intel Mac OS X/ then "Intel Mac OS X"
    when /PPC Mac OS X/   then "Mac OS X"
    when /AmigaOS/        then "Amiga OS"
    else                       "Other OS"
    end
  end

  def browser_type
    my_browser = request.env["HTTP_USER_AGENT"]
    case my_browser
    when /MSIE 8.0/    then "Internet Explorer V8.0"
    when /MSIE 7.0/    then "Internet Explorer V7.0"
    when /MSIE 6.0/    then "Internet Explorer V6.0"
    when /MSIE 5.5/    then "Internet Explorer V5.5"
    when /MSIE 5.22/   then "Internet Explorer V5.22"
    when /MSIE 5.0/    then "Internet Explorer V5.0"
    when /MSIE 4.0/    then "Internet Explorer V4.0"
    when /MSIE 3.0/    then "Internet Explorer V3.0"
    when /MSIE 2.0/    then "Internet Explorer V2.0"
    when /Firefox/     then "Mozilla Firefox"
    when /Camino/      then "Camino"
    when /Dillo/       then "Dillo"
    when /Epiphany/    then "Epiphany"
    when /Firebird/    then "Mozilla Firebird"
    when /Thunderbird/ then "Mozilla Thunderbird"
    when /Geleon/      then "Mozilla Galeon"
    when /IBrowse/     then "IBrowse"
    when /iCab/        then "iCab"
    when /K-Meleon/    then "K-Meleon"
    when /Konqueror/   then "Konqueror"
    when /SeaMonkey/   then "SeaMonkey"
    when /Netscape/    then "Netscape"
    when /OmniWeb/     then "OmniWeb"
    when /Opera/       then "Opera"
    when /Safari/      then "Safari"
    else                    "Other Browser"
    end
  end

  def options_for_contact_us_categories
    [[t("contact_us.form.category_account"),  "Account - #{t("contact_us.form.category_account")} "],
      [t("contact_us.form.category_profile"),  "Profile - #{t("contact_us.form.category_profile")}"],
      [t("contact_us.form.category_security"), "Security - #{t("contact_us.form.category_security")}"],
      ["----------------------------------------------", ''],
      [t("contact_us.form.category_music"),    "Music - #{t("contact_us.form.category_music")}"],
      [t("contact_us.form.category_photos"),   "Photos - #{t("contact_us.form.category_photos")}"],
      [t("contact_us.form.category_other_features"),    'Other Features - #{t("contact_us.form.category_other_features")}'],
      ["----------------------------------------------", ''],
      [t("contact_us.form.category_error"),    "Errors - #{t("contact_us.form.category_error")}"],
      ["----------------------------------------------", ''],
      [t("contact_us.form.category_feedback"),   "Feedback - #{t("contact_us.form.category_feedback")}"],
      ["----------------------------------------------", ''],
      [t("contact_us.form.category_business"),   "Business - #{t("contact_us.form.category_business")}"],
      [t("contact_us.form.category_other"),   "Other - #{t("contact_us.form.category_other")}"],
    ]
  end

  def minimum_width_for_chart(item)
    ratio = item.ratio.to_f
    ratio = ratio.nan? ? 0 : ratio
    length  = chart_length(t("basics.play"))
    ((ratio * 95).to_i < length ? "#{length}" : "#{(ratio * 95).to_i}")
  end

  def chart_length(text)
    case text.length
    when 0..8
      22
    else
      26
    end
  end

  def render_flash
    render 'shared/flash', :flash => flash
  end

  def error_class_for(model, method)
    model.errors.on(method) ? "has_errors" : ""
  end

  def custom_error_message_on(model, method, key=nil)
    key = :"#{model.class.to_s.downcase}.#{method}" if key.nil?
    error_message_on model, method, :prepend_text => (!key.to_s.empty? ? "#{t(key)} " : "")
  end

  def cyloop_logo_path(sm=true)
    sufix = "_sm" if sm

    path = case site_code.to_s
    when 'msnbr'
      'br'
    when 'msnmx'
      'mx'
    when 'msncaen'
      'canada_en'
    when 'msncafr'
      'canada_fr'
    when 'msnlatam'
      'latam'
    when 'msnlatino'
      'latino'
    when 'msnar'
      'ar'
    else
      return '/images/cyloop_logo.png'
    end
    "/images/msn_#{path}_music#{sufix}.png"
  end
  
  def nice_elapsed_time(timestamp)
    time = Time.at(timestamp.to_i)
    distance_of_time_in_words_to_now(time, true)
  end

  def market_logo
    image = image_tag(cyloop_logo_path(false), :id => 'logo', :class => 'png_fix')
    link_to(image, msn_home_page_link_path)
  end

end

