module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name, *args)
    case page_name

    when 'the home'
      root_path(*args)

    when 'the home page'
      root_path(*args)

    when 'the user registration'
      new_user_path(*args)

    when 'the login'
      new_session_path(*args)
    when 'the login page'
      new_session_path(*args)
      

    when 'my color settings'
      my_customizations_path(*args)

    when 'edit my settings'
      edit_my_settings_path(*args)
    when 'edit my settings page'
      edit_my_settings_path(*args)

    when 'edit demographics'
      edit_demographics_path

    # when 'my dashboard'
    #   my_dashboard_path(*args)
    #   request.request_uri =~ /\// ? my_dashboard_path(*args) : my_dashboard_path(*args).gsub('/','')

    # when 'my playlist'
    #   my_playlist_path(*args).gsub('/','')

    when /^(.*)'s not found$/
      profile_not_found_path(:profile => $1, *args)

    when 'my customized css'
      # @current_user.write_customizations
      CustomizationWriter.css_path(@current_user.id)

    when /^my "(.*)" playlist$/
      playlist = Playlist.find_by_name($1)
      my_playlist_path(playlist.id)

    when /^(\w+)'s recent listener javascript$/
      recent_listeners_artist_path(:id => $1.downcase.gsub(' ', '-'), :format => 'js')

    when /^(.*)'s (.*) formatted similar artist$/
      similar_artists_artist_path(:id => $1.downcase.gsub(' ', '-'), :format => $2)

    when /^([\w ]+)'s?$/
      user_path(Account.find_by_name_without_scope($1).slug, *args)

    when /^([\w ]+)'s biography$/
      user_biography_index_path(Account.find_by_name!($1).slug, *args)

    when /^([\w ]+)'s? page$/
      account = Account.find_by_name_without_scope($1)
      send("user_path", account.slug, *args)

    when /^([\w ]+)'s? (.*)$/
      account = Account.find_by_name_without_scope($1)
      send("user_#{$2.gsub(/\W+/,'_')}_path", account.slug, *args)

    when /^(?:his|her)$/
      user_path(@user.slug, *args)

    when /^(?:his|her) (.*)$/
      send("user_#{$1.gsub(/\W+/,'_')}_path", @user.slug, *args)

    when /^the (my .*)( page)?$/, /^(my .*) (page)?$/, /^the (.*) page$/
      send("#{$1.gsub(/\W+/,'_')}_path", *args)

    when 'my dashboard'
      my_dashboard_path(*args)

    when 'my playlist'
      my_playlist_path(*args)
    
    when 'my playlists'
      my_playlists_path(*args)
    
    when 'my customizations'
      my_customizations_path(*args)
    
    when 'my settings'
      my_settings_path(*args)
    when 'my settings page'
      my_settings_path(*args)
    
    
    when 'my stations'
      my_stations_path(*args)
    
    when 'my charts songs'
      my_charts_songs_path(*args)

    when 'my followers'
      my_followers_path(*args)

    when 'my following index'
      my_following_index_path(*args)

    when 'my cancellation feedback'
      my_cancellation_feedback_path(*args)
    
    when 'my cancellation confirm'
      my_cancellation_confirm_path(*args)
    
    when 'my follow requests'
      my_follow_requests_path(*args)
    
    when 'my block'
      my_blocks_path(*args)

    when 'the radio'
      radio_path(*args)
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
