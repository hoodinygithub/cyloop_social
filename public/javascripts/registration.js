jQuery(document).ready(function($){
  function clearValidations(type, input) {
    var parent = $(input).parents('div.row');
    var slug = parent.find("#xhr_"+type);
    slug.removeClass("formError");
  };
  function clearSlugValidations() {
    clearValidations("slug", this);
  }
  function clearEmailValidations() {
    clearValidations("email", this);
  }
  function getFieldName(type) {
    if (type == "email")
      return email_address;
    else
      return text_your_profile;
  }
  function validateRemote(type, input) {
    var input = $(input);
    var value = input.val();
    if(value)
      $.get("/users/errors_on",{field: type, value: value},function(data, status) {
        clearValidations(type, input);
        var parent = input.parents('div.row');
        var container = parent.find("#xhr_"+type);
        if(data.length) {
          parent.find(".formError").hide();
          container.show();
          container.addClass("formError");
          container.removeClass("available")
          parent.find("."+type+"_block").addClass("has_errors");
          container.text(getFieldName(type)+" "+data[0]);
        } else {
          container.removeClass("formError");
          container.addClass("available")
          parent.find("."+type+"_block").removeClass("has_errors");
          parent.find(".fieldWithErrors").removeClass("fieldWithErrors");
          parent.removeClass("has_error");
          container.show();
          if (type=='slug'){
            container.text(text_slug_is_available);
          }else{
            container.text(text_is_available);
          }
        }
      }, 'json');
    else {
      clearValidations(type, input);
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
  }).blur();

  function checkAfterSlug(input, delay) {
    clearTimeout($(input).data("id"));
    $(input).data('id', setTimeout(function() {validateSlug.apply(input)},delay));
  }
  $("#user_slug").keypress(function() {
    checkAfterSlug(this, 1000)
  }).blur(function() {
    checkAfterSlug(this, 0)
  }).blur();
});

Registration = {}
Registration.Layers = {
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

