xml.instruct!
xml.translations( :locale => I18n.locale ) do
  basic = [

    'actions.edit',
    'actions.save',
    'actions.delete',
    'actions.close',
    'actions.submit',

    'albums.label',

    'basics.album',
    'basics.contains',
    'basics.by',
    'basics.includes',
    'basics.message_sent',

    'home.create_your_own_personalized_radio_station',
    'home.type_artist_name',
    'home.create_radio',

    'messenger_player.album.released',
    'messenger_player.buy',
    'messenger_player.checkout_today_polular_stations',
    'messenger_player.msn_stations',
    'messenger_player.now_playing',
    'messenger_player.station.name',
    'messenger_player.station.edit',
    'messenger_player.station.delete',
    'messenger_player.station.would_delete',
    'messenger_player.registration.email',
    'messenger_player.share.title',
    'messenger_player.share.email',
    'messenger_player.share.friend',
    'messenger_player.share.message',
    'messenger_player.station_deleted',
    'messenger_player.station_edit_success',
    'messenger_player.buylink.song',
    'messenger_player.buylink.select_store',
    'messenger_player.continue',
    'messenger_player.recengineerror_NO_RADIO',
    'messenger_player.recengineerror_NO_PLAYLIST',
    'messenger_player.recengineerror_UNKNOWN',
    'messenger_player.activate_your_account',
    'messenger_player.take_a_moment',
    'messenger_player.still_dont_have',
    'messenger_player.sign_in',
    'messenger_player.click_here',
    'messenger_player.we_hope_you_enjoyed',
    'messenger_player.edit_station',
    'messenger_player.msn_music_is_free',
    'messenger_player.view_your_stations',
    'messenger_player.to_login',
    'stations.deleted',
    
    'possessives.first_person.stations',

    'radio.create_new_station',
    'registration.layers.discover',
    { :key => 'registration.layers.discover_text',
      :count => content_tag( :font, number_with_delimiter((current_site.site_statistic.total_artists rescue 0)), :color => '#00A5F8') },
    'registration.layers.listen',
    { :key => 'registration.layers.listen_text', 
      :count => content_tag( :font, number_with_delimiter((current_site.site_statistic.total_songs rescue 0)), :color => '#00A5F8') },
    'registration.layers.share',
    'registration.layers.share_text',
    'registration.you_are',
    'registration.your_name',
    'registration.your_profile_name',
    { :key => 'registration.terms_and_privacy', 
      :terms_link => link_to(t("registration.terms_of_use"), terms_and_conditions_url, :target => '_BLANK'),
      :privacy_link => link_to(t("registration.privacy_policy"), privacy_policy_url, :target => '_BLANK') },

    'share.errors.message.user_name_blank',
    'share.errors.message.user_email_blank',
    'share.errors.message.user_email_invalid',
    'share.errors.message.friend_email_blank',
    'share.errors.message.friend_email_invalid',

    'site.about_cyloop',
    'site.privacy_policy',
    'site.terms_and_conditions',

    'user.male',
    'user.female',
    'user.born_on'
  ]
  basic.each do |item|
    options = {}
    key = if item.is_a?( String )
      item
    else
      options = item
      item.delete(:key)
    end
    xml.translation( :key => key ) do
      xml.cdata!( t(key, options) )
    end
  end

  xml.translation( :key => 'msn_music_logo' ) do
    xml.cdata!( cyloop_logo_path )
  end
  xml.translation( :key => 'msn_home_url' ) do
    xml.cdata!( '/' )
  end
  
  xml.translation( :key => 'user.errors.born_on_required' ) do
    xml.cdata!( t('activerecord.attributes.user.born_on') + ' ' + t('activerecord.errors.messages.blank')  )
  end

  xml.translation( :key => 'user.errors.slug_required' ) do
    xml.cdata!( t('activerecord.attributes.user.slug') + ' ' + t('activerecord.errors.messages.blank')  )
  end

  xml.translation( :key => 'user.errors.gender' ) do
    xml.cdata!( t('activerecord.attributes.user.gender') + ' ' + t('activerecord.errors.messages.gender')  )
  end
  
  xml.translation( :key => 'user.errors.terms_and_privacy_must_be_accepted' ) do
    xml.cdata!( t("registration.terms_and_privacy_must_be_accepted")  )
  end
  
  xml.translation( :key => 'station.errors.name_required' ) do
    xml.cdata!( t('messenger_player.station.name') + ' ' + t('activerecord.errors.messages.blank')  )
  end  

end
