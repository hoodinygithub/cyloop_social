var Base = {
  message_fadeout_timeout: 8000,
  layout: {},
  account_settings: {},
  network: {}
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
  this.layout.hide_success_and_error_messages();
  this.account_settings.highlight_field_with_errors();
};

jQuery(document).ready(
  function() { Base.init(); }
);


