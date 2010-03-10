xml.instruct!
xml.translations( :locale => I18n.locale ) do
  basic = [

    'widget.actions.edit',
    'widget.actions.save',
    'widget.actions.delete',
    'widget.actions.close',
    'widget.actions.submit',

    'widget.albums.label',

    'widget.basics.album',
    'widget.basics.contains',
    'widget.basics.by',
    'widget.basics.includes',
    'widget.basics.message_sent',

    'widget.home.create_your_own_personalized_radio_station',
    'widget.home.type_artist_name',
    'widget.home.create_radio',

    'widget.album.released',
    'widget.buy',
    'widget.checkout_today_polular_stations',
    'widget.msn_stations',
    'widget.now_playing',
    'widget.station.name',
    'widget.station.edit',
    'widget.station.delete',
    'widget.station.would_delete',
    'widget.registration.email',
    'widget.share.title',
    'widget.share.email',
    'widget.share.friend',
    'widget.share.message',
    'widget.buylink.song',
    'widget.buylink.select_store',
    'widget.continue',
    'widget.recengineerror_NO_RADIO',
    'widget.recengineerror_NO_PLAYLIST',
    'widget.recengineerror_UNKNOWN',
    'widget.activate_your_account',
    'widget.take_a_moment',
    'widget.still_dont_have',
    'widget.sign_in',
    'widget.click_here',
    'widget.we_hope_you_enjoyed',
    'widget.view_your_stations',
    'widget.edit_station',
    'widget.msn_music_is_free',
    'widget.to_login',
    'widget.my_stations',
    'widget.create_new_station',
    
    'widget.registration.discover',
    { :key => 'widget.registration.discover_text',
      :count => content_tag( :font, number_with_delimiter((current_site.site_statistic.total_artists rescue 0)), :color => '#00A5F8') },
    'widget.registration.listen',
    { :key => 'widget.registration.listen_text',
      :count => content_tag( :font, number_with_delimiter((current_site.site_statistic.total_songs rescue 0)), :color => '#00A5F8') },
    'widget.registration.share',
    'widget.registration.share_text',
    'widget.registration.you_are',
    'widget.registration.your_name',
    'widget.registration.your_profile_name',
    { :key => 'widget.registration.terms_and_privacy',
      :terms_link => link_to(t("widget.registration.terms_of_use"), terms_and_conditions_url, :target => '_BLANK'),
      :privacy_link => link_to(t("widget.registration.privacy_policy"), privacy_policy_url, :target => '_BLANK') },

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