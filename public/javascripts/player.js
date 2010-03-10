function Player(selector, link_selector) {

  var player = this;

  function find(target) {
    return $(selector).find(target);
  }

  this.showStopButton = function() {
    find('.play').removeClass('on');
  };

  this.showPlayButton = function() {
    find('.play').addClass('on')
  };

  this.stopSound = function() {
    player.showStopButton();
    soundManager.stopAll();
    find('.current_progress').css('width', '0%');
    find('.position').html('0:00');
  }

  this.whilePlaying = function() {
    find('.position').html(player.time(this.position));
    find('.duration').html(player.time(this.durationEstimate));
    find('.current_progress').css('width', this.position / this.durationEstimate * 100 + '%');
  }

  this.time = function(ms) {
    var sec = Math.floor(ms/1000)
    var min = Math.floor(sec/60)
    sec = sec % 60
    sec = (sec>9)?sec:'0'+sec
    return min+':'+sec
  }

  this.createSound = function(url) {
    return soundManager.createSound({
      id: url,
      url: url,
      autoLoad: true,
      onplay: player.showPlayButton,
      whileplaying: player.whilePlaying,
      onfinish: player.stopSound,
      volume: 50
    });
  };

  this.play = function() {
    if(player.current_sound_href) {
      player.createSound(player.current_sound_href);
      soundManager.play(player.current_sound_href);
    }
    return false;
  }

  $(link_selector).live('click', function(e){
    e.preventDefault();
    player.current_sound_href = this.href;
    var title  = $(this).attr('title');
    var artist = $(this).parent().find('cite').text();
    find('.title').html(title);
    find('.artist').html('By: ' + artist);
    soundManager.stopAll();
    player.play();
  });

  $(selector + ' .volume').live('click', function(){
    if($(this).is('.on')) {
      soundManager.mute();
    } else {
      soundManager.unmute();
    }
    $(this).toggleClass('on');
    return false;
  });

  $(selector + ' .play.on').live('click', function(){
    player.stopSound();
    return false;
  });

  $(selector + ' .play:not(.on)').live('click', function(){
    if(player.current_sound_href) {
      player.createSound(player.current_sound_href);
      soundManager.play(player.current_sound_href);
    }
    return false;
  });

}

soundManager.url = '/flash';
var player;
$(document).ready(function() {
  player = new Player('#player','a.player');
});
