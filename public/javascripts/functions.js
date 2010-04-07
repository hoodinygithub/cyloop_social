var listen_icon_timer = null;

$(document).ready(function() {
    //observe userdata arrow button click
    $('#userdata_arrow').click(function() {
        $('#userdata_box .links').slideToggle(200);
        $('#userdata_arrow .arrow_up').toggleClass('visible');
        
        return false;
    });
    $('.png_fix').supersleight({shim: '/images/blank.gif'});
    
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
      clearTimeout(listen_icon_timer);
      $('.unsubscribe_mix', $(this).closest('li')).fadeIn(300);
    }, function() {
      listen_icon_timer = setTimeout(function() {
        $('.unsubscribe_mix').fadeOut(300);
      }, 1000);
    });
    
    $('.unsubscribe_mix').hover(function() {
      clearTimeout(listen_icon_timer);
    }, function() {
      listen_icon_timer = setTimeout(function() {
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
    
    //observe popup close button click
    $('.popup_close, .popup_close_action').click(function() {
      $(this).closest('.popup').fadeOut('fast');
      return false;
    });
});

function clearInput(value, input) {
  if(input.value == value) {
    input.value = '';
  }
}

function restoreInput(value, input) {
  if(input.value == '') {
    input.value = value;
  }
}