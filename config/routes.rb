ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages', :action => 'home'

  # Ads - OpenX
  map.messenger_ads '/messenger_ads', :controller => 'ads', :action => 'show', :position => 'messenger', :iframe => 1, :no_padding_and_margin => 1
  map.cyloop_ads '/cyloop/ads', :controller => 'ads', :action => 'show'

  map.messenger_analytics 'messenger_analytics', :controller => 'messenger_radio', :action => 'analytics'
  map.radio_analytics 'radio_analytics', :controller => 'radio', :action => 'analytics'
  map.fitter_happier 'fitter_happier', :controller => 'fitter_happier'
  map.site_check 'fitter_happier/site_check', :controller => 'fitter_happier', :action => "site_check"
  map.site_and_database_check 'fitter_happier/site_and_database_check', :controller => 'fitter_happier' , :action => "site_and_database_check"
  map.process_with_silence 'fitter_happier/process_with_silence', :controller => 'fitter_happier', :action => "process_with_silence"


  map.home_recommendations_callback '/home.js', :controller => 'pages', :action => 'home', :format => 'js'
  map.home_flash_callback '/flash.js', :controller => 'pages', :action => 'flash_callback', :format => 'js'
  map.header_state_callback '/header.js', :controller => 'pages', :action => 'header_callback', :format => 'js'

  map.resources :users,
                :only => [ :new, :create ],
                :member => { :resend_confirmation_email => :get },
                :collection => { :errors_on => :get, :msn_registration_redirect => :get,
                :msn_login_redirect => :get,
                :follow => :post, :unfollow => :post, :approve => :post, :deny => :post,
                :block => :post, :unblock => :post }

  map.resources :registration_layers, :collection => {
     :test            => :any,
     :follow_artist   => :any,
     :follow_user     => :any,
     :add_song        => :any,
     :radio_add_song  => :any,
     :add_mixer       => :any,
     :max_song        => :any,
     :max_radio       => :any
  }

  map.signup 'signup', :controller => 'users', :action => 'new'
  map.forgot 'forgot', :controller => 'users', :action => 'forgot'
  map.reset 'reset/:reset_code', :controller => 'users', :action => 'reset'
  map.confirmation 'users/confirm/:code', :controller => 'users', :action => 'confirm'
  map.share_with_friend 'share/share_with_friend/:media.:format', :controller => 'share', :action => 'share_with_friend'
  map.share 'share/:media/:id.:format', :controller => 'share', :action => 'show'

  map.x45b 'x45b', :controller => 'application', :action => 'x45b'
  map.x46b 'x46b', :controller => 'pages', :action => 'x46b'

  map.resources :artists, :only => :index, :member => {:recent_listeners => :get, :similar_artists => :get}
  map.resources :players, :only => :show

  map.resource :search
  #map.friendly_empty_search '/search', :controller => 'searches', :action => 'index'
  #map.friendly_empty_search_with_page '/search/empty/:mkt/:scope/:page', :controller => 'searches', :action => 'show'
  map.friendly_search '/search/:scope/:q', :controller => 'searches', :action => 'show'
  map.empty_search '/search/:scope', :controller => 'searches', :action => 'show'

  #map.friendly_search_with_page '/search/:scope/:q/', :controller => 'searches', :action => 'show'
  #map.autocomplete_search '/search/auto/:scope/:q', :controller => 'searches', :action => 'autocomplete'

  map.resources :stations, :collection => {:top => :get, :top_station_html => :get}
  map.delete_station_confirmation '/stations/:id/delete_confirmation', :controller => 'stations', :action => 'delete_confirmation'
  map.delete_station '/stations/:id/delete', :controller => 'stations', :action => 'delete'

  map.resource :activity
  map.resource :artist_recommendations
  map.resource :demographics, :member => {:cities => :get}
  map.resource :session

  map.resources :album_buylinks, :only => :show
  map.resources :song_buylinks, :only => :show
  map.resources :sites_stations, :only => [:index, :show]

  map.login  'login',  :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'

  map.about 'support/about_cyloop', :controller => 'pages', :action => 'about'
  map.terms_and_conditions 'support/terms_and_conditions', :controller => 'pages', :action => 'terms_and_conditions'
  map.privacy_policy 'support/privacy_policy', :controller => 'pages', :action => 'privacy_policy'
  map.safety_tips 'support/safety_tips', :controller => 'pages', :action => 'safety_tips'
  map.faq 'support/faq', :controller => 'pages', :action => 'faq'
  map.feedback 'support/feedback', :controller => 'pages', :action => 'feedback'
  map.contact 'support/contact', :controller => 'pages', :action => 'contact'
  map.contact_us 'support/contact_us', :controller => 'pages', :action => 'contact_us', :collection => [:only_form]
  #map.send_mail 'support/contact/send_mail', :controller => 'pages', :action => 'send_mail'
  map.banner_ads 'pages/banner_ads', :controller => 'pages', :action => 'banner'
  map.block_alert 'support/block_alert', :controller => 'pages', :action => 'block_alert'
  map.profile_not_found ':profile/profile_not_found', :controller => 'pages', :action => 'profile_not_found'
  map.profile_not_available ':profile/profile_not_available', :controller => 'pages', :action => 'profile_not_available'
  map.sample_flag_desc 'support/sample_flag_desc', :controller => 'pages', :action => 'sample_flag_desc'

#  unless RAILS_ENV =~ /production/
  map.with_options(:controller => 'radio') do |url|
    url.radio 'radio', :action => 'index'
    url.artist_info 'radio/my_stations_list', :action => 'my_stations_list'
    url.album_detail 'radio/album_detail', :action => 'album_detail'
    url.twitstation 'twitstation', :action => 'twitstation'
    url.search_radio 'radio/search.:format', :action => 'search'
    url.play_station 'radio/play.:format', :action => 'play'
    url.radio_xml 'radio/:station_id.:format', :action => 'show'
    url.artist_info 'radio/info/:station_id/:artist_id', :action => 'artist_info'
  end

#  end

  # map.namespace :discover do |discover|
  #   discover.resources :artists, :only => [:index, :show]
  #   discover.resources :songs, :only => [:index, :show]
  #   discover.resources :stations, :only => [:index, :show]
  # end
  #map.discover 'discover', :controller => 'discover', :action => 'index'

  # support for in-browser translation in non-production environments
  map.with_options(:path_prefix => 'admin') do |admin|
    Translate::Routes.translation_ui(admin) if RAILS_ENV != "production"
  end

  map.with_options(:controller => 'activities') do |url|
    url.listen_activity 'activity/activity/:type/:song_id', :action => 'song'
    url.get_activity 'activity/activity/:type', :action => 'get_activity'
    url.push_activity 'activity/update/:type', :action => 'update'
    url.get_latest    'activity/latest', :action => 'latest'
    url.get_latest_tweet 'activity/latest_tweet', :action => 'latest_tweet'
  end

  map.messenger_player '/messengerplayer', :controller => 'messenger_player/player', :action => 'index'
  map.connect '/messenger_player', :controller => 'messenger_player/player', :action => 'index'
  map.connect '/messenger_player/player/stats.:format', :controller => 'messenger_player/player', :action => 'stats'
  map.messenger_player_sign_in '/messenger_player/msn_sign_in', :controller => 'messenger_player/player', :action => 'msn_sign_in'
  map.namespace :messenger_player do |player|
    player.resources :stations
    player.resources :translations
    player.resources :users, :collection => { :status => :get }
  end


  map.resources :campaigns, :member => {:activate => :post, :deactivate => :post}

  profile_routes = lambda do |profile|
    profile.resources :comments
    profile.resources :follow_requests
    profile.resources :playlists, :member => {:delete_confirmation => :get}
    profile.resources :playlist_items,:member => {:delete_confirmation => :get}, :only => [:new, :create]
    profile.resources :playlists do |playlist|
      playlist.resources :items, :controller => 'playlist_items', :only => [:show, :update, :destroy]
    end
    profile.queue_my_station '/stations/:station_id/queue', :controller => 'user_stations', :action => "queue"
    profile.resources :albums, :controller => 'albums', :only => [:index, :show]
    map.with_options(:controller => 'albums') do |url|
      url.queue_song ':slug/albums/:id/:song_id', :action => 'show'
    end
    profile.resources :stations, :controller => 'user_stations'

    profile.resources :biography, :only => :index
    profile.resources :following, :controller => 'followees'
    profile.resources :followers
    profile.resources :activities, :only => :index

    profile.resources :charts, :only => :index
    #profile.charts 'charts', :controller => 'charts', :action => 'index'
    profile.namespace :charts do |charts|
      charts.resources :songs, :only => :index
      charts.resources :artists, :only => :index
      charts.resources :albums, :only => :index
    end
  end

  map.namespace :my do |me|
    me.with_options :namespace => '' do |my|
      my.root :controller => 'pages', :action => 'redirect_home'
      profile_routes.call(my)
      my.resource :dashboard, :only => :show

      my.resources :blocks, :only => [:create]

      my.resource :cancellation, :controller => :users, :only => [:destroy, :feedback] do |cancellation|
        cancellation.confirm 'confirm', :controller => 'users', :action => 'confirm_cancellation'
        cancellation.feedback 'feedback', :controller => 'users', :action => 'feedback'
      end
      my.resource :settings, :controller => :users, :only => [:show, :edit, :update], :collection => [:remove_avatar]
      my.resource :customizations, :collection => { :restore_defaults => :get, :remove_background_image => :get }, :path_prefix => 'my/settings'
    end
  end

  map.with_options(:controller => 'custom_artists') do |url|
    url.detour '/detour', :action => 'detour'
    url.invasion '/invasion', :action => 'invasion'
  end

  map.msn_refresh '/msn/refresh', :controller => 'msn/refresh', :action => 'index'
  map.msn_channel '/msn/refresh/channel', :controller => 'msn/refresh', :action => 'channel'

  map.resources :messages, :only => [:index, :new, :create], :path_prefix => 'chat'
  map.justin_tv_chat '/chat/:id/justin_tv', :controller => 'chats', :action => 'justin_tv'
  map.namespace :admin do |admin|
    admin.resources :chats, :member => {:messages => :any, :confirm_remove => :any}
    admin.resources :messages, :only => [:approve, :unapprove, :next, :back, :more, :more_interviewee], :member => {:approve => :any, :unapprove =>:any, :next =>:any, :back =>:any, :more =>:any, :more_interviewee=>:any}
    admin.moderator 'moderator/:id',  :controller => 'messages', :action => 'moderator'
    admin.interviewee 'interviewee/:id', :controller => 'messages', :action => 'interviewee'
  end

  # Need to avoid that auto width from button_to helper
  map.special_followee_update '/my/following/:id/update/:skip_auto_width', :controller => 'followees', :action => 'update'
  map.special_followee_destroy '/my/following/:id/destroy/:skip_auto_width', :controller => 'followees', :action => 'destroy'
  map.followee_destroy '/my/following/:id/destroy', :controller => 'followees', :action => 'destroy'

  # Mapping javascript locale file
  map.javascript_locale '/javascripts/locale.js', :controller => :javascripts, :action => :locale

  # Widget
  map.widget 'widget', :controller => 'popups'
  #map.resources :popups, :collection => {:widget => :any}
  
  # Keep slug routes at the bottom
  map.user ':slug', :controller => 'accounts', :action => 'show'
  map.user_without_slug ':id', :controller => 'accounts', :action => 'show'
  map.namespace :user do |u|
    u.with_options :namespace => '', :path_prefix => ':slug', &profile_routes
  end

  map.artist ':slug', :controller => 'accounts', :action => 'show'
  map.account_rss ':slug.:format', :controller => 'accounts', :action => 'show'

  map.namespace :artist do |a|
    a.with_options :namespace => '', :path_prefix => ':slug' do |artist|
      profile_routes.call(artist)
      artist.resources :songs, :member => {:queue => :post}, :has_many => :playlist_items
    end
  end
  
  map.connect ':controller/:action.:format'
end
