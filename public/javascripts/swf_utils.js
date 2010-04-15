function swf_alert(s)
{
  //alert(s);
  console.log(s);
}

function flash_object(object_name)
{
  try 
  {
    var obj = swfobject.getObjectById(object_name);
    if (obj) 
    {
      return obj;
    } 
    else 
    {
      throw("Flash object not found");
    }
  }
  catch(er) 
  {
    return document.getElementById(object_name);
  }
}

function swf_token()
{
  flash_object("radio_engine").set_token(AUTH_TOKEN);
}

function refresh_ad_unit(id)
{
  iframe = $('#' + id);
  var url = iframe.attr('src');
  if(arguments[1])
  {
    url = url.replace(/[&]?v_songlabel=([^&]+)?/g,"")
    url = url.replace(/[&]?v_songgenre=([^&]+)?/g,"")
    url = url + "&v_songlabel=" + arguments[1].song_label + "&v_songgenre=" + arguments[1].song_genre
  }
  iframe.attr('src', url);
}

function shareSong(idsong)
{
  $.facebox(function()
  {
    $.get('/share/song/' + idsong, function(response)
    {
      $.facebox(response);
    });
  });
}

function collectSong(slug, idsong)
{
  $.facebox(function()
  {
    $.get(slug + '/songs/' + idsong + '/playlist_items/new', function(response)
    {
      $.facebox(response);
    });
  });
}

function buySong(idsong)
{
  $.facebox(function()
  {
    $.get('/song_buylinks/' + idsong, function(response)
    {
      $.facebox(response);
    });
  });
}

function alertLayers(layer)
{
  var url;
  switch(layer)
  {
    case "maxPlays":
    url = "/registration_layers/max_radio";
    break;
    case "maxSongPlays":
    url = "/registration_layers/max_song";
    break;
    case "mixAlert":
    url = "/registration_layers/add_mixer";
    break;
    case "addSongAlert":
    url = "/registration_layers/radio_add_song";
    break;
  }

  $.facebox(function()
  {
    $.get(url, function(response)
    {
      $.facebox(response);
    });
  });
}
