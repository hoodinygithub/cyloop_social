var Base = {
  message_fadeout_timeout: 15000,
  layout: {},
  account_settings: {},
  network: {},
  stations: {},
  header_search: {},
  main_search: {},
  community: {},
  locale: {},
};

/*
 * Layout shared behavior
 */
Base.layout.hide_success_and_error_messages = function() {
  var message = jQuery('.message');
  if (message.length) {
    setTimeout(function() { message.fadeOut(); }, this.message_fadeout_timeout);
  }
};

Base.layout.span_button = function(content) {
  return "<span><span>" + content + "</span></span>";
};

Base.layout.blue_button = function(label) {
  //<a href="/radio" class="full_width blue_button"><span><span>Criar Rádio</span></span></a>

  link = document.createElement('a');
  link.setAttribute('href', '#');
  link.setAttribute('class', 'blue_button');

  span1 = document.createElement('span');
  span2 = document.createElement('span');

  button_label = document.createTextNode(label);
  span2.appendChild(button_label);
  span1.appendChild(span2);
  link.appendChild(span1);

  return link;
};

/*
 * Locales
 */
Base.locale.translate = function(key, params) {
  var translation = Base.locale.content[Base.locale.current][key];

  if (!translation) {
    translation = key + " does not exist";
  }

  // if user pass params like {'count' => 1}
  if (typeof(translation) == 'object') {
    if (typeof(params) == 'object' && typeof(params.count) != 'undefined') {
      if (params.count == 1) {
        translation = translation.one;
      } else {
        translation = translation.other.split('{{count}}').join(params.count);
      }
    }
  }

  return translation;
};

Base.locale.t = function(key, params) {
  return Base.locale.translate(key, params);
};

Base.locale.date_difference = function(old_date, new_date) {
  old_date      = new Date(old_date * 1000);

  if (typeof(new_date) == 'undefined') {
    new_date   = new Date();
  } else {
    new_date   = new Date(new_date * 1000);
  }

  date_diff     = new Date(new_date - old_date).getTime();

  weeks = Math.floor(date_diff / (1000 * 60 * 60 * 24 * 7));
  date_diff -= weeks * (1000 * 60 * 60 * 24 * 7);

  days = Math.floor(date_diff / (1000 * 60 * 60 * 24));
  date_diff -= days * (1000 * 60 * 60 * 24);

  hours = Math.floor(date_diff / (1000 * 60 * 60));
  date_diff -= hours * (1000 * 60 * 60);

  minutes = Math.floor(date_diff / (1000 * 60));
  date_diff -= minutes * (1000 * 60);

  seconds = Math.floor(date_diff / 1000);
  date_diff -= seconds * 1000;

  old_time_ago_str = "";

  if (days > 0) {
    old_time_ago_str = Base.locale.t('datetime.distance_in_words.x_days', {'count':days});
  } else if (hours > 1) {
    old_time_ago_str = Base.locale.t('datetime.distance_in_words.x_hours', {'count':hours});
  } else if (minutes > 1) {
    old_time_ago_str = Base.locale.t('datetime.distance_in_words.x_minutes', {'count':minutes});
  } else if (seconds > 30) {
    old_time_ago_str = Base.locale.t('datetime.distance_in_words.x_seconds', {'count':seconds});
  } else {
    old_time_ago_str = Base.locale.t('datetime.distance_in_words.less_than_x_seconds', {'count':seconds});
  }

  return old_time_ago_str + " ago";
};

/*
 * Community
 */
Base.community.follow = function(user_slug, button, remove_div) {
  var params = {'user_slug':user_slug}
  var $button = jQuery(button);
  var old_onclick = $button.attr('onclick');

  $button_label = $button.children().children();
  $button_label.html("...");

  $button.attr('onclick', "");
  $button.bind('click', function() { return false; });

  jQuery.post('/users/follow', params, function(response, status) {
    if (status == 'success') {
      $button.removeClass("blue_button");
      $button.addClass("green_button");
      $button_label.html(Base.locale.t('actions.unfollow'));
      $button.unbind('click');
      $button.bind('click', function() { Base.community.unfollow(user_slug, this, remove_div); return false; });
    }
  });
};

Base.community.unfollow = function(user_slug, button, remove_div) {
  var params = {'user_slug':user_slug}
  var $button = jQuery(button);
  var old_onclick = $button.attr('onclick');

  $button_label = $button.children().children();
  $button_label.html("...");

  $button.attr('onclick', "");
  $button.bind('click', function() { return false; });

  jQuery.post('/users/unfollow', params, function(response, status) {
    if (status == 'success') {
      if (remove_div) {
        $button.parent().parent().slideUp();
      } else {
        $button.removeClass("green_button");
        $button.addClass("blue_button");
        $button_label.html(Base.locale.t('actions.follow'));
        $button.unbind('click');
        $button.bind('click', function() { Base.community.follow(user_slug, this, remove_div); return false; });
      }
    }
  });
};

Base.community.block = function(user_slug, button) {
  var params = {'user_slug':user_slug}
  var $button = jQuery(button);
  var old_onclick = $button.attr('onclick');
  var $main_div = $button.parent().parent().parent();
  var $black_ul = $button.parent().parent();
  var $settings_button = $main_div.find('.settings_button').children().children();

  $black_ul.fadeOut();
  $settings_button.html("<img src='/images/blue_loading.gif'></img>");

  jQuery.post('/users/block', params, function(response, status) {
    if (status == 'success') {
      $main_div.find('.blocked').html("<img src='/images/blocked.gif'></img> " + Base.locale.t('blocks.blocked'));
      $button.attr('onclick', "");
      $button.unbind('click');
      $button.bind('click', function() { Base.community.unblock(user_slug, this); return false; });
      $button.html(Base.locale.t('actions.unblock'));
      $settings_button.html("<img src='/images/settings_button.png'></img>");
    }
  });
};

Base.community.unblock = function(user_slug, button) {
  var params = {'user_slug':user_slug}
  var $button = jQuery(button);
  var old_onclick = $button.attr('onclick');
  var $main_div = $button.parent().parent().parent();
  var $black_ul = $button.parent().parent();
  var $settings_button = $main_div.find('.settings_button').children().children();

  $black_ul.fadeOut();
  $settings_button.html("<img src='/images/blue_loading.gif'></img>");

  jQuery.post('/users/unblock', params, function(response, status) {
    if (status == 'success') {
      $main_div.find('.blocked').html("");
      $button.attr('onclick', "");
      $button.unbind('click');
      $button.bind('click', function() { Base.community.block(user_slug, this); return false; });
      $button.html(Base.locale.t('actions.block'));
      $settings_button.html("<img src='/images/settings_button.png'></img>");
    }
  });
};


/*
 * Stations
 */
Base.stations.edit = function(user_station_id, button) {
  $button = jQuery(button);
  $station_text = $button.parent().parent();
  $station_name_container = $station_text.find('.station_name');
  $buttons = $station_text.find('.buttons');

  old_station_name_content = $station_name_container.html();
  old_station_name = $station_name_container.text().replace(/^\s+|\s+$/g, "");

  station_name_input = document.createElement('input');
  station_name_input.setAttribute('type', 'text');
  station_name_input.setAttribute('id', 'station_' + user_station_id + '_input');
  station_name_input.setAttribute('value', old_station_name);

  old_buttons_content = $buttons.html();

  done_button = jQuery(Base.layout.blue_button('Done'));
  done_button.bind('click', function() {
    new_station_input = jQuery('#station_' + user_station_id + "_input");
    new_station_name = new_station_input.val();
    new_station_input.attr('readOnly', true);

    $buttons.hide();
    params = {'_method' : 'put', 'user_station' : {'name':new_station_name} };
    jQuery.post('/my/stations/' + user_station_id, params, function(response) {
      new_station_name_content = old_station_name_content;
      new_station_name_content = new_station_name_content.split(old_station_name).join(new_station_name);
      $buttons.html(old_buttons_content).show();
      $station_name_container.html(new_station_name_content);
    });

    return false;
  });

  cancel_button = jQuery(Base.layout.blue_button('Cancel'));
  cancel_button.bind('click', function() {
    $station_name_container.html(old_station_name_content);
    $buttons.html(old_buttons_content);
    return false;
  });


  $buttons.html("");
  $buttons.append(done_button);
  $buttons.append("&nbsp;");
  $buttons.append(cancel_button);

  $station_name_container.html(station_name_input);
};


Base.stations.remove = function(user_station_id, button) {
  $button = jQuery(button);
  $station_text = $button.parent().parent();
  $buttons = $station_text.find('.buttons');
  $li = $button.parent().parent().parent();

  $buttons.hide();

  jQuery.post('/my/stations/' + user_station_id, {'_method':'delete'}, function(response) {
    if (response == 'destroyed') {
      $li.slideUp();
    } else {
      $buttons.show();
    }
  });
};

Base.stations.close_button_event_binder = function() {
  jQuery("span.recommended_station").bind('click', function() { Base.stations.close_button_handler(this); });
};

Base.stations.close_button_handler = function(object) {
    $button = jQuery(object);
    var artist_id = $button.attr('artist_id');

    $parent_div = $button.parent();
    $parent_div.html("<img style='margin-top:50px' src='/images/loading.gif'></img>");
    $parent_div.css({'background':'#cccccc', 'text-align':'center'});

    var new_artist_id = recommended_stations_queue.shift();

    if (typeof(new_artist_id) == 'undefined') {
      $parent_div.html("");
      $parent_div.css({'background':'white', 'text-align':'left'});
      return;
    }

    var params = {'artist_id':new_artist_id, 'last_box':$parent_div.hasClass('last_box')};
    jQuery.get('/stations/top_station_html', params, function(data) {
      $new_div = jQuery(data);
      $parent_div.html($new_div.html());
      $parent_div.css({'background':'white', 'text-align':'left'});
      Base.stations.close_button_event_binder();
    });
};


/*
 * Comment shared
 */
Base.network.update_page = function(list) {
  $network_update_text = jQuery('#network_update_text');
  $show_more_button = jQuery('#show_more_comments');
  $comment_list        = jQuery('#network_comment_list');
  var $share_button = jQuery('a.compartir_button');

  $share_button.fadeOut();

  first_element = list[0];
  user_slug = first_element.user_slug;
  timestamp = first_element.timestamp;
  str_timestamp = first_element.str_timestamp;

  username = user_slug;
  bold_username = document.createElement('b');
  bold_username.appendChild(document.createTextNode(username));
  break_line = document.createElement('br');
  time_ago = document.createElement('span')
  time_ago.setAttribute('class', 'grey');
  time_ago.setAttribute('timestamp', timestamp);
  time_ago.appendChild(document.createTextNode(str_timestamp));
  spanned_comment = document.createElement('span');
  spanned_comment.setAttribute('class', 'comment_text_container');
  spanned_comment.appendChild(document.createTextNode(first_element.message));

  $network_update_text.html("").hide();
  $network_update_text.append(bold_username);
  $network_update_text.append(document.createTextNode(" - "));
  $network_update_text.append(spanned_comment);
  $network_update_text.append(break_line);
  $network_update_text.append(time_ago);
  $network_update_text.fadeIn();

  $comment_list.html("");
  for (var i=list.length-1; i > 0 ; i--) {
    activity = list[i];
    old_time_ago_str = "123";

    $text_div = jQuery('<div></div>');
    $text_div.attr('class', 'comment_text');

    $bold_username = jQuery('<b></b>');
    $link_to_user_str = jQuery('<a></a>');
    $link_to_user_str.attr('href', '#');
    $link_to_user_str.append(activity.user_slug);
    $bold_username.append($link_to_user_str);

    $timestamp_span = jQuery('<span></span>');
    $timestamp_span.attr('timestamp', activity.timestamp);
    $timestamp_span.attr('class', 'grey');
    $timestamp_span.append(activity.str_timestamp);

    $text_div.append($bold_username);
    $text_div.append('<br />');
    $text_div.append(activity.message);
    $text_div.append('<br />');
    $text_div.append($timestamp_span);

    $avatar_image = jQuery('<img></img>');
    $avatar_image.attr('src', activity.user_avatar);
    $link_to_user = jQuery('<a></a>');
    $link_to_user.attr('href', '#');
    $link_to_user.append($avatar_image);

    $clearer = jQuery('<div></div>');
    $clearer.attr('class', 'clearer');

    $new_li = jQuery('<li></li>');
    $new_li.append($link_to_user);
    $new_li.append($text_div);
    $new_li.append($clearer);

    $comment_list.prepend($new_li);
  }

  $share_button.fadeIn();

  if ($comment_list.find('li').length >= 5) {
    $show_more_button.fadeIn();
  }
};

Base.network.load_latest = function() {
  jQuery(document).ready(function() {
    $form = jQuery('#network_update_form');
    jQuery.post('/activity/latest', function (response) {
      $form.show();
      Base.network.update_page(response);
    });
  });
};


Base.network.push_update = function() {
  $network_update_text = jQuery('#network_update_text');
  $show_more_button = jQuery('#show_more_comments');
  $comment_field       = jQuery("#network_comment");
  $comment_field.css({'border':'10px solid #EDEDED'});

  var comment = jQuery.trim($comment_field.val());
  var $old_network_update_text = $network_update_text.clone();
  var $share_button = jQuery('a.compartir_button');
  $share_button.fadeOut();

  if (comment && comment.length > 0) {
    jQuery.post('/activity/update/status', {'message':comment}, function (response) {
      $comment_field.val("");
      Base.network.update_page(response);
    });
  } else {
    $comment_field.css({'border':'10px solid red'});
    $share_button.fadeIn();
  }

  return false;
};

/*
 * Account settings page
 */
Base.account_settings.highlight_field_with_errors = function() {
  if (typeof(field_with_errors) != 'undefined') {
    for(i=0; i < field_with_errors.length; i++) {

      field_name = field_with_errors[i][0];
      field_error = field_with_errors[i][1];

      field = jQuery('#user_' + field_name);
      grey_box = field.parent().parent();
      field.css({'border':'1px solid white'});
      grey_box.css({'color':'white', 'background':'red', 'border':'2px solid red'});
      message = jQuery("<br /><span>" +  field_error + "</span>")
      message.css({'color':'white', 'font-size':'0.8em'});
      grey_box.append(message);
    }
  }
};


/*
 * header search
 */

Base.header_search.getFieldValue =  function(arr, fieldName) {
  for(i=0; i<arr.length; i++) {
    if (arr[i].name == fieldName) {
      return arr[i].value;
    }
  }
};

Base.header_search.buildSearchUrl = function () {
  var form_values = jQuery("#header_search_form").serializeArray();
  var q     = Base.header_search.getFieldValue(form_values,'q');
  var mkt   = Base.header_search.getFieldValue(form_values,'mkt');
  var scope = 'any'
  var url   = "/search/"+(q=="" ? "empty/" : "")+mkt+"/"+scope+"/"+q;
  location.href = url;
  return false;
};

Base.header_search.dropdown = function() {
  jQuery("#search_query").keyup(function(e) {
      jQuery('.search_results_ajax').show();
      var keyCode = e.keyCode || window.event.keyCode;
      var form_values = jQuery("#header_search_form").serializeArray();
      var q           = Base.header_search.getFieldValue(form_values,'q');
      if(keyCode == 37 || keyCode == 38 || keyCode == 39 || keyCode == 40){
        return;
	  }
      if(keyCode == 13 || keyCode == 27 || q.length==1){
        jQuery('.search_results_ajax').show();
        jQuery('.search_results_box').hide();
        return;
  	  }
      jQuery('.search_results_box').show();
      setTimeout(function () {Base.header_search.autocomplete(q)}, 500);
      return true;
    });
};

Base.header_search.autocomplete = function(last_value) {
  jQuery('.search_results_ajax').show();
  var form_values = jQuery("#header_search_form").serializeArray();
  var q           = Base.header_search.getFieldValue(form_values,'q');
  if( last_value != q || q == ''){
    jQuery('search_results_ajax').hide();
    return;
  }
  jQuery.get('/search/autocomplete/'+q, function(data) {
      jQuery('.search_results_box').html(data);
      jQuery('search_results_ajax').hide();
  });
};

/*
 * main search
 */

Base.main_search.buildSearchUrl = function () {
  var form_values = jQuery("#main_search_form").serializeArray();
  var q     = Base.header_search.getFieldValue(form_values,'q');
  var mkt   = Base.header_search.getFieldValue(form_values,'mkt');
  var scope = Base.header_search.getFieldValue(form_values,'scope');
  var url   = "/search/"+(q=="" ? "empty/" : "")+mkt+"/"+scope+"/"+q;
  location.href = url;
  return false;
};

Base.main_search.highlight_scope = function() {
    jQuery(".scope a").each(function(el) {
      jQuery(this).removeClass('active');
    });
    value = jQuery("#search_scope").get(0).value;
    jQuery("#search_" + value).addClass('active')
  };

Base.main_search.select_scope = function() {
  jQuery(".scope a").click(function() {
      value = this.id.match(/search_(.*)/)[1];
      $('#search_scope').attr('value', value);
      Base.main_search.highlight_scope()
      return false;
    });
    $('#main_search_form').submit(function() {
      scope = $('#search_scope').attr('value');
    });
    Base.main_search.highlight_scope()
};


/*
 * Register and triggers
 */
Base.init = function() {
  $('#slides').cycle({fx: 'fade', timeout: 5000, pager: '#pager_links'});
  this.stations.close_button_event_binder();
  this.layout.hide_success_and_error_messages();
  this.account_settings.highlight_field_with_errors();
  this.header_search.dropdown();
};

jQuery(document).ready(
  function() { Base.init(); }
);

