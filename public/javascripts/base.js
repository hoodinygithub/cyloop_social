var Base = {
  message_fadeout_timeout: 8000
};

Base.hide_success_and_error_messages = function() {
  var message = jQuery('.message');
  if (message.length) {
    setTimeout(function() { message.fadeOut(); }, this.message_fadeout_timeout);
  }
};

Base.highlight_field_with_errors = function() {
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

Base.init = function() {
  jQuery('.png_fix').supersleight({shim: '../images/blank.gif'});
  jQuery('#slides').cycle({fx: 'fade', timeout: 5000, pager: '#pager_links'});
  this.hide_success_and_error_messages();
  this.highlight_field_with_errors();
};

jQuery(document).ready(
  function() { Base.init(); }
);