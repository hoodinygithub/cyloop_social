var Base = {
  message_fadeout_timeout: 15000,
  listen_icon_timer: null,
  layout: {},
  account_settings: {},
  network: {},
  stations: {},
  header_search: {},
  main_search: {},
  community: {},
  locale: {},
  utils: {},
  registration: {},
  radio: {},
  account: {}
};

/*
 * Utils
 */
var clearInput = function(value, input) {
 if(input.value == value) {
   input.value = '';
 }
}

var restoreInput = function(value, input) {
 if(input.value == '') {
   input.value = value;
 }
}

/*
 * Simple validation utility.  I want to refactor this
 */
var validateSubmission = function(form, elem)
{
  var errors = [];
  var validate;
  var element_value;

  for(var x = 0; x < elem.length; x++)
  {
    for(var i in elem[x])
    {
      validate = elem[x][i];
      element = form.find('#' + i);
      element_value = form.find('#' + i).attr('value');

      if(validate == 'required')
      {
        if(element_value == '')
        {
          errors.push(error_codes[i + '_blank']);
          element.parent().attr("class", "red_round_box");
        }
        else
        {
          element.parent().attr("class", "grey_round_box");
        }
      }

      if(validate == 'required_email')
      {
        if(element_value == '')
        {
          errors.push(error_codes[i + '_blank']);
          element.parent().attr("class", "red_round_box");
        }
        else if(element_value != '')
        {
          element.parent().attr("class", "grey_round_box");
          var reg = /^([A-Za-z0-9_\-\.\+])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
          if(!reg.test(element_value))
          {
            errors.push(error_codes[i + '_invalid']);
            element.parent().attr("class", "red_round_box");
          }
        }
      }

      if(validate == 'required_multiemail')
      {
        if(element_value == '')
        {
          errors.push(error_codes[i + '_blank']);
          element.parent().attr("class", "red_round_box");
        }
        else if(element_value != '')
        {
          element.parent().attr("class", "grey_round_box");
          var reg = /^([A-Za-z0-9_\-\.\+])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
          var multi = element_value.split(',');
          for(var j = 0; j < multi.length; j++)
          {
            if(!reg.test(multi[j].replace(/^\s*|\s*$/g,'')))
            {
              errors.push(error_codes[i + '_invalid']);
              element.parent().attr("class", "red_round_box");
              break;
            }
          }
        }
      }
    }
  }

  if(errors.length > 0)
  {
    return false;
  }
  else
  {
    return true;
  }
}

$(document).ready(function() {
  $("#facebox a.close_after_click").live("click", function() {
      $(document).trigger("close.facebox");
      return true;
  });

  /*
   * Capture share station submission
   */
  $("#facebox .share_station form").live("submit", function(e) {
      e.preventDefault();
      if(validateSubmission($(this), validations))
      {
        $.ajax({
          url: $(this).attr('action'),
          type: $(this).attr('method'),
          data: $(this).serialize(),
          success: function(r) {$.facebox( r );},
          error: function(r)   {$('#facebox. .share_station .content').html(r.responseText);}
        });
      }
  });
});

var swf = function(objname) 
{
  if(navigator.appName.indexOf("Microsoft") != -1)
    return window[objname];
  else
    return document[objname];
};

Base.radio.set_station_details = function(id, queue, play) {
  $("#station_id").val(id);
  $("#station_queue").val(queue);
	if(play || typeof(play)=='undefined') { Base.radio.play_station(false, false, null, null); }
};

Base.radio.refresh_my_stations = function() {
  $.ajax({
    type: "GET",
    url:  "/radio/my_stations_list",
    data: {station_id: $("#station_id").val()},
    success: function(result) {
      $("div#my_stations_container").empty();
      $("div#my_stations_container").append(result);
		  $("div#my_stations_list .songs_box ul li a.launch_station").click(function(e){
		  	e.preventDefault();
				var is_station_list_item = $(this).hasClass('launch_station');
				var is_create_station_submit = $(this).attr("id") == "create_station_submit";
				var list;
				var list_play_button;
				if(is_station_list_item) {
					var li = $(this).parentsUntil('li');
					list = this.id.match(/(.*)_list(.*)/)[1];
					list_play_button = li.find('img.list_play_button');
					if(list_play_button) { list_play_button.attr('src', "/images/grey_loading.gif"); }
				}
				Base.radio.set_station_details($(this).attr('station_id'), $(this).attr('station_queue'), false);
				Base.radio.play_station(is_station_list_item, is_create_station_submit, list, list_play_button)
   		});
  	}
	});
};

Base.radio.play_station = function(from_list, from_create_station, list, list_play_button ) {
	var id =  $("#station_id").val();
	var queue =  $("#station_queue").val();
	var is_owner = $("#owner").val() == 'true';
	
  $.ajax({
    type: "GET",
    url:  "/radio/album_detail",
    data: {station_id: id},
    success: function(result) {
			if(from_list) {
				if(list_play_button) { list_play_button.attr('src', "/images/icon_play_small.gif"); }
				toggleButton(list, 0);
			}
			if(from_create_station) {
				$('#collapse_create_new_station').click();
			}
      $("div#current_station_info").empty();
      $("div#current_station_info").append(result);
      $("div#current_station_info").append("<br class='clearer' />");
			initCreateStationButton();
			
			if(is_owner){
			  Base.radio.refresh_my_stations();
			}

      swf("cyloop_radio").queueStation(id, queue);
    }
  });
};

Base.radio.initialize = function() {
	var elems = "div.songs_box ul li a.launch_station, #create_station_submit";
	
  $(elems).click(function(e){
      e.preventDefault();
			var is_station_list_item = $(this).hasClass('launch_station');
			var is_create_station_submit = $(this).attr("id") == "create_station_submit";
			var list;
			var list_play_button;			
			if(is_station_list_item) {
				var li = $(this).parentsUntil('li');
				list = this.id.match(/(.*)_list(.*)/)[1];
				list_play_button = li.find('img.list_play_button');
				if(list_play_button) { list_play_button.attr('src', "/images/grey_loading.gif"); }
			}
			Base.radio.set_station_details($(this).attr('station_id'), $(this).attr('station_queue'), false);
			Base.radio.play_station(is_station_list_item, is_create_station_submit, list, list_play_button)
/*      $.ajax({
        type: "GET",
        url:  "/radio/album_detail",
        data: {station_id: stationId},
        success: function(result) {
					if(is_station_list_item) {
						if(list_play_button) { list_play_button.attr('src', "/images/icon_play_small.gif"); }
						toggleButton(list, 0);
					}
					if(is_create_station_submit) {
						$('#collapse_create_new_station').click();
					}
          $("div.album_detail").empty();
          $("div.album_detail").append(result);
          $("div.album_detail").append("<br class='clearer' />");

					if(is_owner){
						Base.radio.refresh_my_stations();
					}

          swf("cyloop_radio").queueStation(stationId, station);
        }
      });
*/  });
};

Base.utils.handle_login_required = function(response, url, button_label) {
  if (typeof(response) == 'object') {
    if (typeof(response.status) && response.status == 'redirect') {
      $.simple_popup(function()
      {
        $.get(url, function(response)
        {
          $.simple_popup(response);
          button_label.html(Base.locale.t('actions.follow'));
        });
      });
      return true;
    }
  }
  return false;
};

Base.utils.redirect_layer_to = function(url, code, event) {
  var targ = Base.utils.get_target(event);
  if (targ && targ.tagName != "A") {
    pageTracker._trackPageview(code);
    location.href = url;
  }
}

Base.utils.get_target = function(e) {
  var targ;
  if (!e) var e = window.event;
  if (e.target) targ = e.target;
  else if (e.srcElement) targ = e.srcElement;
  if (targ.nodeType == 3) // defeat Safari bug
    targ = targ.parentNode;
  return targ;
}



/*
 * Layout shared behavior
 */
Base.layout.hide_success_and_error_messages = function() {
  var message = jQuery('.message');
  if (message.length) {
    setTimeout(function() { message.fadeOut(); }, Base.message_fadeout_timeout);
  }
};

Base.layout.bind_events = function() {
  //observe userdata arrow button click
  $('#userdata_arrow').click(function() {
      $('#userdata_box .links').slideToggle(200);
      $('#userdata_arrow .arrow_up').toggleClass('visible');

      return false;
  });

  //observe followers setting button click
  $('.settings_button').click(function() {
      $('.actions_settings', $(this).closest('.follower_actions')).slideToggle('fast');

      return false;
  });

  //observe .artist_box mouse over
  $('.artist_box').hover(function() {
    $(this).addClass('hover');
  }, function() {
    $(this).removeClass('hover');
  });


  //observe accordion tabs
  $('.accordion_title').click(function() {
      $(this).toggleClass('expanded');
      $(this).next().slideToggle(200);

      return false;
  });

  //observe listen_icon button mouse over
  $('.listen_icon').hover(function() {
    clearTimeout(Base.listen_icon_timer);
    $('.unsubscribe_mix', $(this).closest('li')).fadeIn(300);
  }, function() {
    Base.listen_icon_timer = setTimeout(function() {
      $('.unsubscribe_mix').fadeOut(300);
    }, 1000);
  });

  $('.unsubscribe_mix').hover(function() {
    clearTimeout(Base.listen_icon_timer);
  }, function() {
    Base.listen_icon_timer = setTimeout(function() {
      $('.unsubscribe_mix').fadeOut(300);
    }, 1000);
  });


  //observe .songs_box mouse over
  $('.hoverable_list > li').hover(function() {
    $(this).addClass('hover');
  }, function() {
    $(this).removeClass('hover');
  });

  //observe .rule_tooltip mouse over
  $('.rule').hover(function() {
    $t = $('.rule_tooltip', this);
    $t.css('top', -($t.height()/2));
    $t.stop();
    $t.fadeTo(400, 1);
  }, function() {
    $t.fadeOut(2000);
  });
  $('.rule_tooltip').hover(function() {
    $(this).stop();
    $(this).fadeTo(100,1);
  });
}

Base.layout.spin_image = function(type, no_margin) {
  if (typeof(type) == 'undefined' || !type) {
    image_name = 'blue_loading.gif';
  } else {
    image_name = type + "_loading.gif";
  }
  $img = jQuery("<img></img>");
  $img.attr('src', '/images/' + image_name);


  if (typeof(no_margin) == 'undefined' || no_margin) {
    $img.css({'margin-top':'5px'});
  }

  return $img;
};

Base.layout.spanned_spin_image = function(type, no_margin) {
  $img = Base.layout.spin_image(type, no_margin);
  $span1 = jQuery('<span></span>');
  $span2 = $span1.clone();
  $span2.append($img);
  $span1.append($span2);

  return $span1;
};

Base.layout.span_button = function(content) {
  return "<span><span>" + content + "</span></span>";
};

Base.layout.blue_button = function(label, options) {
  link = document.createElement('a');
  link.setAttribute('href', '#');
  link.setAttribute('class', 'blue_button');

  span1 = document.createElement('span');
  span2 = document.createElement('span');

  button_label = document.createTextNode(label);
  span2.appendChild(button_label);
  span1.appendChild(span2);
  link.appendChild(span1);

  if (typeof(options) == 'object' && typeof(options.width) != 'undefined') {
    link.setAttribute('style', "width: " + options.width + ";");
  }

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

  return old_time_ago_str + " "+Base.locale.t('datetime.ago');
};

/*
 * Community
 */
Base.community.approve = function(user_slug, link) {
  Base.community.__follow_request_handler('approve', user_slug, link, function(response) {
    $follower_list = jQuery('ul.followers_list');
    $li = jQuery("<li></li>").hide().append(response);
    $follower_list.append($li.fadeIn());
  });
};

Base.community.disaprove = function(user_slug, link) {
  Base.community.__follow_request_handler('disaprove', user_slug, link, function(response) {
    alert("d =>" + response);
  });
};

Base.community.__follow_request_handler = function(type, user_slug, link, callback) {
  var params           = {'user_slug':user_slug};
  var $link            = jQuery(link);
  var $main_element    = $link.parent().parent().parent().parent();
  var $pending_title   = jQuery('li.pending');
  var $black_ul        = $link.parent().parent();
  var $settings_button = $main_element.find('.settings_button').children().children();

  $black_ul.fadeOut();
  $settings_button.html(Base.layout.spin_image(false, false));

  jQuery.post('/users/' + type, params, function(response, status) {
    $main_element.slideUp();
    $pending_items = jQuery('li.pending_item:visible');
    if ($pending_items.length == 1) {
      $pending_title.slideUp();
    }
    if (typeof(callback) == 'function') callback(response);
  });
};

Base.community.follow = function(user_slug, button, remove_div, layer_path) {
  var params = {'user_slug':user_slug}
  var $button = jQuery(button);
  var old_onclick = $button.attr('onclick');

  $button_label = $button.children().children();
  $button_label.html(Base.layout.spanned_spin_image());

  $button.attr('onclick', "");
  $button.bind('click', function() { return false; });

  jQuery.post('/users/follow', params, function(response, status) {
    if (Base.utils.handle_login_required(response, layer_path, $button_label)) {
      $button.unbind('click');
      $button.bind('click', function() {
        Base.community.follow(user_slug, button, remove_div, layer_path);
        return false;
      });
      return;
    }
    
    if (status == 'success') {
      $button_label.html("");
      $button.removeClass("blue_button");
      $button.addClass("green_button");
      if (response.status == 'following') {
        $button_label.html(Base.locale.t('actions.unfollow'));
      } else if (response.status == 'pending') {
        $button_label.html(Base.locale.t('actions.pending'));
      }

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
  $button_label.html(Base.layout.spanned_spin_image('green'));

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
  //$settings_button.html("<img src='/images/blue_loading.gif'></img>");
  $settings_button.html(Base.layout.spin_image(false, false));

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
  // $settings_button.html("<img src='/images/blue_loading.gif'></img>");
  $settings_button.html(Base.layout.spin_image(false, false));

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

Base.stations.share = function(station_id) {
  var url = "/share/station/" + station_id;
  $.popup(function()
  {
    $.get(url, function(response)
    {
      $.popup(response);
    });
  });
};

Base.stations.edit_from_layer = function() {	
  station_id = $('#layer_station_id').val();
  playable_id = $('#playable_id').val();
  new_station_name = $('#new_station_name').val();

  if(new_station_name == '') { alert(blank_station_alert); return false; }
	jQuery('#edit_loading').removeClass('hide');

  params = {'_method' : 'put', 'user_station' : {'name': new_station_name} };
  jQuery.post('/my/stations/' + playable_id, params, function(response) {
		if(parseInt(station_id, 10) == parseInt($('#station_id').val(), 10)) {
			jQuery('#station_name').html(new_station_name);
		}
	jQuery('#my_stations_list_name_' + station_id).html(new_station_name);
	jQuery(document).trigger('close.facebox');
  });
};

Base.stations.init_delete_layer = function() {
  jQuery("#delete_station_button").click(function() {
		var station_id = parseInt(jQuery("#station_to_delete").val(), 10);
		if(station_id > 0) {
			jQuery('#delete_loading').removeClass('hide');	
		  jQuery.post('/stations/' + station_id + "/delete", {'_method':'delete'}, function(response) {
				jQuery(document).trigger('close.facebox');
		    if (response == 'destroyed') {
					jQuery('#station_to_delete').attr('value', 0);
		      $('#my_station_item_' + station_id).slideUp('fast');
		    } 
			});
		}
	  return false;
  });
};

Base.stations.launch_edit_layer = function(station_id) {
  $.popup(function() {
		url = '/stations/' + station_id + '/edit';
  		jQuery.get(url, function(data) {
      jQuery.popup(data);
    });
	});  
 	return false;
};


Base.stations.remove_from_layer = function(station_id) {
	jQuery("#station_to_delete").attr('value', station_id);
  $.popup(function() {
		url = '/stations/' + station_id + '/delete_confirmation';
  		jQuery.get(url, function(data) {
      jQuery.popup(data);
    });
	});  
	
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
Base.network.show_more = function(button) {
  $button = jQuery(button);

  $span_label = $button.find('span').find('span');
  old_button_label = $span_label.html();
  $span_label.html(Base.layout.spin_image());

  // activities page
  $list   = jQuery('.followers_list');

  if ($list.length == 0) {
    $list = jQuery(".comments_list");
  }

  if ($list.length == 0) {
    throw("Could not find a valid list element.");
  }

  $last_li  = $list.find('li:last');
  timestamp = $last_li.attr('timestamp');
  
  var params = {'after':timestamp, 'slug':Base.account.slug};
  if (typeof(Base.network.FILTER_BY) != 'undefined') {
    params.filter_by = Base.network.FILTER_BY;
  }
  
  jQuery.post("/activity/latest", params, function (response) {
    $list.html(response).fadeIn();
    $span_label.html(old_button_label);
  });
};

Base.network.count_chars = function() {
  $textarea     = jQuery("#network_comment");
  $chars_counter = jQuery(".chars_counter");

  if ($textarea.val().length < 140) {
    $chars_counter.css({'color':'#cccccc'});
    $chars_counter.html(140 - $textarea.val().length);
  } else {
    $chars_counter.css({'color':'red'});
    $chars_counter.html("0");
    $textarea.val( $textarea.val().substr(0, 140) );
  }
};

Base.network.__update_page_owner_page = function(response, options) {
  $show_more_button = jQuery('#show_more_comments');
  $comment_list        = jQuery('#network_comment_list');
  $share_button = jQuery('a.compartir_button');  

  if (typeof(options) == 'object' && typeof(options.replace) != 'undefined' && options.replace) {
    $comment_list.hide().html(response).fadeIn();
  } else {
    $comment_list.hide().append(response).fadeIn();
  }
  
  if (response.length > 0) {
    $show_more_button.fadeIn();
  }
  
  $share_button.fadeIn();
};

Base.network.__update_page_user_page = function(response) {
  $user_big_text = jQuery("#user_activity_big_text");
  $ul = jQuery('#user_recent_activities');

  $user_big_text.find('img').remove();

  if (response.length == 0) {
    $user_big_text.find('span').fadeIn();
    return;
  }

  $user_big_text.remove();
  $ul.html(response);
};


Base.network.load_latest = function(params, profile_owner) {
  jQuery(document).ready(function() {
    var user_page = jQuery('#user_recent_activities').length > 0;

    if (typeof(params) != 'object') params = {};

    if (user_page) {
      params.public = true;
    }
    
    params.profile_owner = profile_owner;

    jQuery.post('/activity/latest', params, function (response) {
      if (user_page) {
        Base.network.__update_page_user_page(response);
      } else {
        jQuery(".chars_counter").show();
        jQuery('#network_update_form').show();
        Base.network.__update_page_owner_page(response);
      }
    });
  });
};

Base.network.__artist_latest_tweet = function(response) {
  $user_big_text = jQuery("#tweet_big_text");
  $msg = jQuery('#tweet_recent_activities');
  $user_big_text.find('img').remove();

  $user_big_text.remove();
  $msg.html(response).fadeIn();
}

Base.network.load_latest_tweet = function(params) {
  jQuery(document).ready(function() {
    if (typeof(params) != 'object') params = {};
    jQuery.post('/activity/latest_tweet', params, function (response) {
      Base.network.__artist_latest_tweet(response);
    });
  });
};


Base.network.push_update = function() {
  $network_update_text = jQuery('#network_update_text');
  $show_more_button    = jQuery('#show_more_comments');
  $comment_field       = jQuery("#network_comment");
  $chars_counter       = jQuery(".chars_counter");
  $comment_field.css({'border':'10px solid #EDEDED'});

  var comment = jQuery.trim($comment_field.val());
  var $old_network_update_text = $network_update_text.clone();
  var $share_button = jQuery('a.compartir_button');
  $share_button.fadeOut();

  if (comment && comment.length > 0) {
    jQuery.post('/activity/update/status', {'message':comment}, function (response) {
      $comment_field.val("");
      jQuery(".chars_counter").html(140);
      Base.network.__update_page_owner_page(response, {'replace':true});
      $chars_counter.css({'color':'#cccccc'});
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
      grey_box.addClass('with_error');
      message = jQuery("<br /><span class=\"field_message\">" +  field_error + "</span>")
      grey_box.append(message);
    }
    Base.account_settings.focus_first_section_with_error($('span.fieldWithErrors input').first());
  }
};

Base.account_settings.focus_first_section_with_error = function(field_error) {
  $('div.accordion_box').hide().prev().removeClass('expanded');
  field_error.closest('div.accordion_box')
             .slideToggle(200)
             .prev()
             .toggleClass('expanded');
};

Base.account_settings.focus_first_field_with_error_by_label = function() {
  var field_error = $('span.fieldWithErrors input').first();
  $('div.accordion_box').hide().prev().removeClass('expanded');
  field_error.closest('div.accordion_box')
             .slideToggle(200, function() {
               field_error.focus();
             })
             .prev()
             .toggleClass('expanded');
};


Base.account_settings.add_website = function() {
  var value = $(this).val().replace('http://', '');
  $('#websites_clearer').before('<div class="website_row">' +
   '<input id="user_websites_" name="user[websites][]" type="hidden" value="' + value + '" />' +
   '<b><big><a href="http://' + value + '">' + value + '</a></big> &nbsp; ' +
   '<a href="#" class="black delete_site">[' + Base.locale.t('account_settings.delete') + ']</a></b><br/></div>');
  $('.delete_site').click(Base.account_settings.delete_website);
  $(this).val('');
  return false;
};

Base.account_settings.delete_website = function() {
  $(this).closest('.website_row').remove();
  return false;
};

Base.account_settings.update_avatar_upload_info = function() {
  $('#avatar_upload_info').text($(this).val());
};

Base.account_settings.delete_account_submit_as_msn = function() {
  var form = $(this).closest('form');
  var validator = form.validate();
  if (form.valid()) {
    $.popup(function() {
      jQuery.get('/my/cancellation/confirm', function(data) {
        jQuery.popup(data);
      });
    });
  } else {
    validator.showErrors();
  }
  return false;
}

Base.account_settings.delete_account_submit_as_cyloop = function() {
  var form = $(this).closest('form');
  var validator = form.validate();
  if (form.valid()) {
    password_value = $("#delete_password").val();
    $.ajax({
      type : "DELETE",
      url  : "/my/cancellation",
      data : { delete_info_accepted: "true", delete_password: password_value },
      success: function(data){
        if (data.success) {
          window.location = data.redirect_to;
        } else {
          validator.showErrors(data.errors);
        }
      }
    });
  } else {
    validator.showErrors();
  }
  return false;
}


Base.account_settings.delete_account_confirmation = function() {
  $.ajax({
    type : "DELETE",
    url  : "/my/cancellation",
    data : { delete_info_accepted: "true"},
    success: function(data){
      delete_account_data = data;
      $.popup(function() {
        jQuery.get('/my/cancellation/feedback', function(data) {
          jQuery.popup(data);
        });
        cancelled_account_email = data.email;
      });
      $(document).bind('close.facebox', function() {
        window.location = data.redirect_to;
      });
    }
  });
  return false;
}

Base.account_settings.send_feedback = function() {
  $('#redirect_to').val(delete_account_data.redirect_to);
  var form = $('#feedback_form').closest('form').submit();
}

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
  var url   = "/search/all/" + ( q == msg ? "" : q) ;
  location.href = url;
  return false;
};

Base.header_search.dropdown = function() {
  jQuery("#search_query").keyup(function(e) {
      jQuery('.search_results_ajax').show();
      var keyCode = e.keyCode || window.event.keyCode;
      var form_values = jQuery("#header_search_form").serializeArray();
      var q = Base.header_search.getFieldValue(form_values,'q');
      if(keyCode == 37 || keyCode == 38 || keyCode == 39 || keyCode == 40){
        return;
	  }
      if(keyCode == 13 || keyCode == 27 || q.length <= 1){
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
  var q = Base.header_search.getFieldValue(form_values,'q');
  if( last_value != q || q == ''){
    jQuery('search_results_ajax').hide();
    return;
  }
  jQuery.get('/search/all/' + q, function(data) {
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
  var scope = Base.header_search.getFieldValue(form_values,'scope');
  var sort = Base.header_search.getFieldValue(form_values,'sort');
  var url   = "/search" + (scope == "" ? "/all" : "/" + scope) + "/" + q + "?sort_by=" + sort;
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

Base.main_search.toggle_scope = function() {
		Base.main_search.highlight_scope();
  	value = jQuery("#search_scope").get(0).value;
 	  jQuery(".scope_toggle a").each(function(el) {
	    if(this.id != "scope_" + value + "_toggle") {
				jQuery(this).removeClass('active');
			}
	  });
		jQuery("#scope_" + value + "_toggle").addClass('active');

	  jQuery(".scope_result").each(function(el) {
	    if(this.id != value + "_result") {
	     jQuery(this).addClass('hide');
			}
	  });
		jQuery("#" + value + "_result").removeClass('hide');
  };


Base.main_search.follow = function(user_slug, element) {
  var $element = jQuery(element);
  var params = {'user_slug':user_slug}
  jQuery.post('/users/follow', params, function(response, status) {
    login_required = Base.utils.handle_redirect(response);
    if (login_required) return;
    if (status == 'success') {
      jQuery($element).parent().parent().find('#not_following').hide();
      jQuery($element).parent().parent().find('#following').show();
    }
  });
};

Base.main_search.unfollow = function(user_slug, element) {
  var $element = jQuery(element);
  var params = {'user_slug':user_slug}
  jQuery.post('/users/unfollow', params, function(response, status) {
    if (status == 'success') {
      jQuery($element).parent().parent().find('#not_following').show();
      jQuery($element).parent().parent().find('#following').hide();
    }
  });
};


Base.main_search.select_scope = function() {
  jQuery(".scope a").click(function() {
      value = this.id.match(/search_(.*)/)[1];
      $('#search_scope').attr('value', value);
      Base.main_search.highlight_scope();
      return false;
    });
    $('#main_search_form').submit(function() {
      scope = $('#search_scope').attr('value');
    });
    Base.main_search.highlight_scope();
};

Base.main_search.initialize_scope_toggle = function() {
	Base.main_search.select_scope();
  jQuery(".scope_toggle a").click(function() {
      value = this.id.match(/scope_(.*)_toggle/)[1];
      $('#search_scope').attr('value', value);      
			Base.main_search.toggle_scope();
      return false;
    });
  jQuery(".sorting a").click(function() {						
      $('#search_sort').attr('value', this.href.match(/sort_by\=(.*)/)[1]);
			Base.main_search.buildSearchUrl();
      return false;
    });

};


Base.registration.layers = {
  removeSomeFaceboxStyles: function() {
    $('#facebox .body').css("padding", 0);
    $('#facebox .body').css("background-color", "transparent");
    $(document).bind("close.facebox", function(){
      setTimeout(function() {
        $('#facebox .body').css("padding", "10px");
        $('#facebox .body').css("background-color", "white");
      }, 600);
    });
  }
}


Base.radio.init_edit_station_layer = function() {

	jQuery("#edit_station_name").click(function() {
	  $.popup(function() {
			url = '/stations/' + jQuery('#station_id').val() + '/edit';
   		jQuery.get(url, function(data) {
	      jQuery.popup(data);
	    });
		});
	});
	return false;
/*	jQuery("#station_name").click(function() {
		jQuery('.popup').popup();
	});
*/	
  save_button.bind('click', function() {
    params = {'_method' : 'put', 'user_station' : {'name': new_station_name } };
    jQuery.post('/my/stations/' + user_station_id, params, function(response) {			
      jQuery("#station_name").html(new_station_name);
			jQuery(document).trigger('close.facebox');
    });

    return false;
  });
};

/*
 * Register and triggers
 */
jQuery(document).ready(function() { 
  // Effects and Layout fixes
  $('#slides').cycle({fx: 'fade', timeout: 5000, pager: '#pager_links'});
  $('.png_fix').supersleight({shim: '/images/blank.gif'});
  
  // Popups
  $('.simple_popup').simple_popup();
  $('.popup').popup();
  
  Base.stations.close_button_event_binder();
  Base.layout.bind_events();
  Base.layout.hide_success_and_error_messages();
  Base.header_search.dropdown();
});

