$(document).ready(function() {
  $("li.listen .tools .play, ul.playlists .tools .play, .tools .pause").livequery('click', function(e) {
    if(!clicked)
    {
      li = $(this).parents("li");
      track_switch(li);
      setTimeout("toggle_player(li)", 700);
      clicked = true;
    }
    return false;
  });

  $(".header_tools .shuffle_off, .header_tools .shuffle_on").livequery('click', function(e) {
    if(!clicked)
    {
      if (shuffle) {
        shuffle = false;
      }
      else
      {
        shuffle=true;
      }
      restyle_header();
    }
    return false;
  });


  if(autoplay == true)
  {
    if(song_id != null)
    {
      li = $("ul.playlists li[song_id='" + song_id + "']");
      setTimeout("toggle_player(li)", 700);
    }
    else
    {
      li = $("ul.playlists li:eq(0), ul.activities li:eq(0)");
      setTimeout("toggle_player(li)", 700);
    }
  }
});

$(window).unload(function() {
  unload_tracker();
})

function unload_tracker(){
  if(active_layer && player_status != "COMPLETE")
  {
    try {
      flash_object("player").track_media();
    } catch (er) {
      // suppress this error
    }
  }
}

function do_toggle(t){
  if(!clicked)
  {
    var type = $(t).attr("class").split(" ")[0];
    switch(type)
    {
      case "station":
      window.location = $(t).find(".play a").attr("href");
      break;
      case "playlist":
      window.location = $(t).find("h4 a").attr("href");
      break;
      case "listen":
      default:
      clicked = true;
      li = $(t);
      track_switch(li);
      setTimeout("toggle_player(li)", 700);
      break;
    }
  }
  return false;
}

function track_switch(li)
{
  if(active_layer)
  {
    if(active_layer.attr("id") != li.attr("id") && player_status != "COMPLETE")
    {
      refresh_ad_unit('square_banner', {song_label:li.attr("label"), song_genre:li.attr("genre")});
      try {
        flash_object("player").track_media();
      } catch (ex) {
        //this code raises an exception after an ajax call on profile dashboard page
        //it doesn't look really necessary, but as the call was here, i'm not removing it
        //I know a blank catch block IS HORRIBLE but i couldn't find any other solution right nw
        //#TODO find a solution for this crap
      }
      active_layer.attr("notrack", 1);
    }
  }
  else
  {
    refresh_ad_unit('square_banner', {song_label:li.attr("label"), song_genre:li.attr("genre")});
  }
}

var li;
var test;
var song_id;
var toggle_timeout;
var active_layer;
var flash_vars = {};
var set_player = false;
var autoplay = false;
var player_status;
var clicked = false;
var shuffle = false;

function initialize_player() {
  set_player = true;
  player_state("CREATED");
  restyle(active_layer, "PLAYING");
  active_layer.toggleClass("active");

  play_media(flash_vars)
}

function generate_player(flash_vars) {
  var width, height, asset;

  var sec = $("body").attr('class');
  sec = sec.split(" ")[0];
  if(sec == "dashboards" || sec == "accounts")
  {
    width = "240";
    height = "18";
    asset = "/flash/inline_media_player_small.swf";
  }
  else
  {
    width = "300";
    height = "18";
    asset = "/flash/inline_media_player.swf";
  }

  if (flash_vars) {
    flash_vars.wmode = "transparent";
  } else {
   flash_vars = {wmode:"transparent"};
  }
  var params       = {wmode:"transparent"};
  var attributes   = {id:"player", name:"player"}

  swfobject.embedSWF(asset, "player_obj", width, height, "9", false, flash_vars, params, attributes);
}

function reset_player()
{
  active_layer.find(".media_player").empty();
  restyle(active_layer, "PAUSED");
  active_layer.toggleClass("active");
  set_player = false;
}

function toggle_player(li)
{
  clicked = false;
  if(!active_layer)
  {
    active_layer = li;
  }
  else
  {
    if(active_layer.attr("id") != li.attr("id"))
    {
      reset_player();
      active_layer = li;
    }
  }

  if(set_player == false)
  {
    flash_vars.artist_id = active_layer.attr("artist_id");
    flash_vars.song_id   = active_layer.attr("song_id");
    flash_vars.song_file = active_layer.attr("song_file");
    flash_vars.track     = active_layer.attr("notrack");
    flash_vars.PLAYERKEY = active_layer.attr("player_key");
    flash_vars.LOCALE    = $('body').attr('locale');
    flash_vars.LOGGEDIN  = $('body').attr('loggedin');
    flash_vars.MARKET    = $('body').attr('market');

    var player_obj = document.createElement("div");
    player_obj.id = "player_obj";
    active_layer.find(".media_player").append(player_obj);

    generate_player(flash_vars);
    setTimeout("initialize_player();", 700);
  }
  else
  {
    flash_object("player").play_pause();
    restyle(active_layer, player_status);
  }
}

function restyle(element, status)
{
  switch(status)
  {
    case "PLAYING":
    element.find(".tools a:eq(0)").removeClass("play");
    element.find(".tools a:eq(0)").addClass("pause");
    break;
    case "PAUSED":
    element.find(".tools a:eq(0)").removeClass("pause");
    element.find(".tools a:eq(0)").addClass("play");
    break;
  }
}

function restyle_header()
{
    if (shuffle)
    {
      $(".header_tools a:eq(0)").removeClass("shuffle_off");
      $(".header_tools a:eq(0)").addClass("shuffle_on");
    }
    else
    {
      $(".header_tools a:eq(0)").removeClass("shuffle_on");
      $(".header_tools a:eq(0)").addClass("shuffle_off");
    }
}


function play_media(obj_vars)
{
  var obj = flash_object("player");
  try
  {
    obj.play_media(obj_vars);
  }
  catch(er)
  {
    // Try load object again (issue with FF and Vista)
    set_player = false;
    active_layer.find(".media_player").empty();
    restyle(active_layer, "PAUSED");
    active_layer.toggleClass("active");
    toggle_player(li);
  }
}

function player_state(state)
{
  player_status = state;
  if(state == "COMPLETE" && $("ul.playlists, ul.activities").children().length > 1)
  {
    if($('#activity_type_filters li a#all').hasClass('active'))
      reset_player();
    else
    {
      if (shuffle)
        shuffle_song();
      else
        next_song();
    }
  }
  if(state == 'CLOSE')
  {
    reset_player();
  }

}

function next_song()
{
  var index = $("ul.playlists, ul.activities").children().index(active_layer);
  var count = $("ul.playlists, ul.activities").children().length;
  if((index + 1) < count)
  {
    idx = index + 1
  }
  else
  {
    idx = 0;
  }
  li = $("ul.playlists li:eq(" + idx + "), ul.activities li:eq(" + idx + ")");
  refresh_ad_unit('square_banner', {song_label:li.attr("label"), song_genre:li.attr("genre")});
  setTimeout("toggle_player(li)", 700);
}

function shuffle_song()
{
  var count = $("ul.playlists, ul.activities").children().length;
  idx = Math.floor(count * (Math.random() % 1));
  li = $("ul.playlists li:eq(" + idx + "), ul.activities li:eq(" + idx + ")");
  refresh_ad_unit('square_banner', {song_label:li.attr("label"), song_genre:li.attr("genre")});
  setTimeout("toggle_player(li)", 700);
}
