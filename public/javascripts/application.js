var follow_profile = false;

// FIX PNG'S HERE
function fixAlphaPng() {
  var pill_left = $(".pill_button .left");
  var pill_right = $(".pill_button .right");
  var pngfix = new Array();
  pngfix = [pill_left, pill_right, $("#cyloop_logo"),  $(".logo_separator"), $("#msn_logo_msnmx"), $("#msn_logo_msnbr"), $("#msn_logo_msnlatam"), $("#msn_logo_msncaen"), $("#msn_logo_msncafr"), $('#msn_logo_msnlatino')];
  //$("div.pill_button > a"), $("div.pill_button > span"), $("div.pill_button > button"), $("div.pill_button > input.pill_button"
  for(i = 0; i < pngfix.length; i++)
  {
    if(pngfix[i] != undefined)
    {
      pngfix[i].ifixpng();
    }
  }
}

var hasSubmittedRegistration = false;

jQuery(document).ready(function($){

  $('input:text, input:password').addClass('text');
  $('input:checkbox').addClass('checkbox');

  $('.rounded').corners();
  $('.rounded').corners(); /* test for double rounding */
	$("input[type=text][id$=_on]").datepicker($.datepicker.regional[jQuery.trim($('#calendar_locale').text())]);

	$("input[type=text][id$=_on]").datepicker('option', $.extend({
		dateFormat: "dd-mm-yy",
    changeMonth: true,
    changeYear: true,
    yearRange: '-100:0'
	}));

  // FIX PNG'S HERE
	fixAlphaPng();

  $.facebox.settings.opacity = 0.5;
  $("a.facebox").livequery(function() {
    $(this).click(function() {
      return false;
    }).facebox();
  });

	// clone website field
	$('a.add_more').click(function() {
          lastidx = $('.field.multiple_input_fields').children().index($('.input_wrapper.web:last')) + 1;
          if(lastidx < 5 )
          {
            $('.input_wrapper.web:last').clone(true).insertAfter('.input_wrapper.web:last');
            cloned = $('.input_wrapper.web:last :input')
            cloned.attr('name', 'user[websites][]');
            cloned.attr('id', 'user_websites_');
            cloned.val('');
            if(lastidx == 4) $('.field.multiple_input_fields .add_more').remove();
          }
	  return false;
	});

  $('#new_playlist').livequery(function() {
    $(this).change(function() {
      var target = $(this).parents('form:first').find('.creation');
      if($(this).attr('checked')) {
        target.show();
      } else {
        target.hide();
      }
    }).change();
  });

  $("#facebox .close").live('click', $.facebox.close);

  $("#facebox a.close_after_click").live( 'click', function () {
    jQuery(document).trigger('close.facebox');
    return true;
  } );

  $('#facebox .share_song form').livequery('submit', function(e) {
      e.preventDefault();
      var validations = [
                          {user_name:'required'},
                          {user_email:'required_email'},
                          {friend_email:'required_multiemail'}
                        ];

      if(validateSubmission($(this), validations))
      {
        $.ajax({
          url: $(this).attr('action'),
          type: $(this).attr('method'),
          data: $(this).serialize(),
          success: function(r) {jQuery.facebox( r );},
          error: function(r)   {$('#facebox. .share_song .content').html(r.responseText);}
        });
      }
  });

  $('#facebox .playlists_list form, #facebox .block_alert form, #facebox #edit_station form, #facebox .edit_playlist form, #facebox .delete_confirmation form').livequery('submit', function(e) {
     $(this).ajaxSubmit( {complete: function () {$(document).trigger('close.facebox');}, dataType : 'script'} );
     return false;
  });

  $('#search_main').hover(function() {
	  $('#nav_main ul.options').css('display', 'block');
  }, function() {
	  $('#nav_main ul.options').css('display', 'none');
  });

  HeaderSearch.init();

  jQuery(document).ajaxSend(function(event, request, settings) {
    if(settings.type == "GET") return;
    if(settings.contentType != "application/x-www-form-urlencoded") return;
    if(/\bauthenticity_token=/.test(settings.data)) return;
    var token = $("meta[name=authenticity_token]").attr("content");
    if(!token) return;
    if(settings.data)
      settings.data += "&";
    else {
      request.setRequestHeader("Content-Type",settings.contentType);
      settings.data = "";
    }
    settings.data += "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
  });

  $('#msn_header .portal').hide();
  $('#msn_header li.more a').click(function() {
    $("#msn_header .portal").toggle();
    $("#msn_header li.more").toggleClass('open');
    return false;
  });

  $( "#new_user" ).submit( function( e ) {
    if ( !hasSubmittedRegistration ){
      hasSubmittedRegistration = true;
      $( "#user_submit" ).text( $( "#user_submit" ).attr("loading") );
      return true;
    } else {
      e.preventDefault();
      return false;
    }
  } );

});

function validateSubmission(form, elem)
{
  $('ul.error').css('display', 'none');

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
          element.css('border-color', '#FF0000');
        }
        else
        {
          element.css('border-color', '#999999');
        }
      }

      if(validate == 'required_email')
      {
        if(element_value == '')
        {
          errors.push(error_codes[i + '_blank']);
          element.css('border-color', '#FF0000');
        }
        else if(element_value != '')
        {
          element.css('border-color', '#999999');
          var reg = /^([A-Za-z0-9_\-\.\+])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
          if(!reg.test(element_value))
          {
            errors.push(error_codes[i + '_invalid']);
            element.css('border-color', '#FF0000');
          }
        }
      }

      if(validate == 'required_multiemail')
      {
        if(element_value == '')
        {
          errors.push(error_codes[i + '_blank']);
          element.css('border-color', '#FF0000');
        }
        else if(element_value != '')
        {
          element.css('border-color', '#999999');
          var reg = /^([A-Za-z0-9_\-\.\+])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
          var multi = element_value.split(',');
          for(var j = 0; j < multi.length; j++)
          {
            if(!reg.test(multi[j].replace(/^\s*|\s*$/g,'')))
            {
              errors.push(error_codes[i + '_invalid']);
              element.css('border-color', '#FF0000');
              break;
            }
          }
        }
      }

    }
  }

  if(errors.length > 0)
  {
    printErrors(errors);
    return false;
  }
  else
  {
    return true;
  }
}

function printErrors(err)
{
  if($('ul.error li').length > 0) $('ul.error').empty();
  $('ul.error').css('display', 'block');
  for(var i = 0; i < err.length; i++)
  {
    $('ul.error').append('<li>' + err[i] + '</li>');
  }
}

var test_event = null;

function getTarget(e) {
	var targ;
	if (!e) var e = window.event;
	if (e.target) targ = e.target;
	else if (e.srcElement) targ = e.srcElement;
	if (targ.nodeType == 3) // defeat Safari bug
		targ = targ.parentNode;  
	return targ;
}

function redirectLayerTo(url, code, event) {
  var targ = getTarget(event);
  if (targ && targ.tagName != "A") {
    pageTracker._trackPageview(code);
    location.href = url;    
  }
}

HeaderSearch = {
  getFieldValue: function(arr, fieldName) {
    for(i=0; i<arr.length; i++) {
      if (arr[i].name == fieldName) {
        return arr[i].value;
      }
    }
  },
  buildSearchUrl: function () {
    var formValues = $("#header_search_form").serializeArray();
    var activeOption = $(".search .options .active")[0].id;
    if (activeOption == "search_web") {
      // Bing
      return true;
    } else {
      var q     = HeaderSearch.getFieldValue(formValues, 'q');
      var mkt   = HeaderSearch.getFieldValue(formValues, 'mkt');
      var scope = HeaderSearch.getFieldValue(formValues, 'scope');        
      var url   = "/search/"+(q=="" ? "empty/" : "")+mkt+"/"+scope+"/"+q;
      location.href = url;
      return false;        
    }
  },
  highlightActiveOption: function() {
    $(".search .options li a").each(function(el) {
      $(this).removeClass('active');
    });
    value = $("#search_scope").get(0).value;
    $("#search_" + value).addClass('active')
  },
  init: function() {
    $(".search .options li a").click(function() {
      value = this.id.match(/search_(.*)/)[1];
      $('#search_scope').attr('value', value);
      if (value == 'web') {
        $("#header_search_form").attr('action', 'http://www.bing.com/search')
      }
      HeaderSearch.highlightActiveOption();
      return false;
    });
    $('#header_search_form').submit(function() {
      scope = $('#search_scope').attr('value');
    });
    HeaderSearch.highlightActiveOption();
  }
}