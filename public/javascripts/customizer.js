var customizerInitialized;

function initCustomizer() {

  if (customizerInitialized) return;

  function updatePagePreview(field_name, new_value) {
    $("li.color." + field_name).css('background-color', new_value);
    field_name = "user_color_" + field_name;
    if (field_name == "user_color_header_bg") {
      $("#header_wrapper, #mast_head").css('backgroundColor', new_value);
    } else if (field_name == "user_color_main_font") {
      $("#page_wrapper").css('color', new_value);
    } else if (field_name == "user_color_links") {
      $("#page_wrapper a, #page_wrapper a:visited, .navigation a, .additional_meta .time .count, .additional_meta .songs .count, #playlists_container span.count, .additional_meta .time .count, .additional_meta .songs .count, #stats_following_count, #stats_visits_count, #stats_followers_count, #stats_song_plays_count, #stats_visits_count, #stats_total_listens_count, div#list_header span.count").css('color', new_value);
      $("#page_wrapper .chart div.bar, .chart div.bar_right, div#start_listening .button").css('background-color', new_value);
    } else if (field_name == "user_color_bg") {
      $("body").css('backgroundColor', new_value);
    }
  }

  $('#customizer li').each(function() {
    var field_name = $(this).attr('class').match(/([^ ]+) .+/)[1];
    
    $(this).ColorPicker({
      associated_field: field_name,
      onBeforeShow: function() {
        $(this).ColorPickerSetColor($(".color_field." + field_name + " input").get(0).value);
        $(".background_image").hide();
        $(".background_align").hide();
        $(".background_repeat").hide();
        $(".background_fixed").hide();
      },
      onChange: function(something, hex) {
        textbox = $('#user_color_' + field_name).get(0);
        textbox.value = hex.toUpperCase();
        updatePagePreview(field_name, '#' + hex);
      },
      onHide: function(){
        $(".background_image").show();
        $(".background_align").show();
        $(".background_repeat").show();
        $(".background_fixed").show();
      }
    })

  })

  $('#customizer_restore_defaults').click(function() {
    window.location = '/my/settings/customizations/restore_defaults';
    return false;
  })

  $('#customizer_cancel').click(function() {
    updatePagePreview('header_bg', '#' + default_header_bg);
    updatePagePreview('main_font', '#' + default_main_font);
    updatePagePreview('links',     '#' + default_links);
    updatePagePreview('color_bg',  '#' + default_color_bg);
    $('#customizer').hide("blind");
    return false;
  })

  $('#customizer .color_field').each(function() {
    field_name = $(this).children('input[type="text"]').get(0).id;
    x = $(this).children('input[type="text"]')
    .ColorPicker({
      associated_field: field_name,
      onBeforeShow: function() {
        $(this).ColorPickerSetColor(this.value);
      },
      onChange: function(something, hex) {
        field_name = $(this).attr('associated_field');
        textbox = $('#' + field_name).get(0);
        textbox.value = hex.toUpperCase();
        updatePagePreview(field_name, '#' + hex);
      }
    });
  });
}

$(document).ready(function() {
  $('#profile_label #customize_page_link').click(function() {
      if (customizerInitialized) {
        $("#customizer").toggle("blind");
      } else {
        $.get("/my/settings/customizations/edit.js", {}, new Function(), 'script');
      }
      return false;
    });
});
