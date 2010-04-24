jQuery(document).ready(function($){

  function validateRemote(type, input) {
    var input = $(input);
    var value = input.val();
    if(value)
      $.get("/users/errors_on",{field: type, value: value},function(data, status) {
        Base.account_settings.clear_info_and_errors_on(input);
        if (data.length) {
          Base.account_settings.add_message_on(input, data[0], data[1]);
        } else {
          Base.account_settings.add_message_on(input,  data[0], data[2]);
        }
      }, 'json');
    else {
      Base.account_settings.clear_info_and_errors_on(input);
    }
  };

  function validateSlug() {
    validateRemote("slug", this);
  }

  function validateEmail() {
    validateRemote("email", this);
  }

  function checkAfterEmail(input, delay) {
    clearTimeout($(input).data("id"));
    $(input).data('id', setTimeout(function() {validateEmail.apply(input)},delay));
  }

  $("#user_email").keypress(function() {
    checkAfterEmail(this, 1000)
  }).blur(function() {
    checkAfterEmail(this, 0)
  });

  function checkAfterSlug(input, delay) {
    clearTimeout($(input).data("id"));
    $(input).data('id', setTimeout(function() {validateSlug.apply(input)},delay));
  }

  $("#user_slug").keypress(function() {
    checkAfterSlug(this, 1000)
  }).blur(function() {
    checkAfterSlug(this, 0)
  });

});
