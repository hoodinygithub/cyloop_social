var Base = {
  message_fadeout_timeout: 4000
};

Base.hide_success_and_error_messages = function() {
  var message = jQuery('.message');
  if (message.length) {
    setTimeout(function() { message.fadeOut(); }, this.message_fadeout_timeout);
  }
};

Base.init = function() {
  this.hide_success_and_error_messages();
};

jQuery(document).ready(
  function() { Base.init(); }
);