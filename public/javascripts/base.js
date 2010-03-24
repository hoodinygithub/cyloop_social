var Base = {
  message_fadeout_timeout: 8000,
  layout: {},
  account_settings: {},
  network: {},
  stations: {}
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

/*
 * Stations
 */
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
Base.network.submit_form = function() {
  $comment_field = jQuery('#network_update_form');
  comment_text = $comment_field[0].comment.value;
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
 * Register and triggers
 */
Base.init = function() {
  jQuery('.png_fix').supersleight({shim: '../images/blank.gif'});
  jQuery('#slides').cycle({fx: 'fade', timeout: 5000, pager: '#pager_links'});
  this.stations.close_button_event_binder();
  this.layout.hide_success_and_error_messages();
  this.account_settings.highlight_field_with_errors();
};

jQuery(document).ready(
  function() { Base.init(); }
);

