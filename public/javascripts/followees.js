$(document).ready(function() {

  //$("#mycarousel li form").each(function(form) { 
  //  $(form).submit(function(e) { 
  //    url = $(this).attr("action");
  //    $(form).get(":button")
  //    e.stopPropagation();
  //    return false;
  //  })
  //});

  $("form.button-to[action*=/my/following/]").livequery('submit', function(e) {
    form = $(this).parent();
    url = $(this).attr("action");
    method = $($(this).attr("_method")).attr("value")
    $.ajax({ type: method, url: url,
      success: function(response, status) {
        $(form).html(response);
      }
    })
    e.stopPropagation();
    return false;
  })

});
