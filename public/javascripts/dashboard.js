$(document).ready(function() {
  $("#customize_button").show();
  $("#results").hide();
  $("#reload").click(function() {
    $.ajax({
      type: "GET",
      url: "/discover/artists",
      success: function(response) {
        $("#recommended_artists").html(response);
      }
    })
  });

  $('.songs_private').sortable({
    update: function(event, ui) {
      to_index = $(this).children('li').index(ui.item) + 1;
      song_id = ui.item.get(0).id.match(/song_(\d+)/)[1];
      $.ajax({
        type: "GET",
        url: window.location.href + "/change_song_position",
        data: "song_id=" + song_id + "&new_position=" + to_index,
        beforeSend: function() {
          $("#saving_notifier").show();
        },
        error: function() {
          alert("The playlist order could not be changed. Please try again later.");
          window.location.reload(true);
        },
        complete: function() {
          $("#saving_notifier").hide();
        }
      })
    }
  });

  /////////////////////////////////////////////////////
  // WHAT DO YOU WANT TO LISTEN TO LOGIC AND METHODS //
  /////////////////////////////////////////////////////

  $("#artist_result .song .avatar").livequery(function(e){
    $(this)
      .hover(function()
      {
        var tip = $(this).parent().find("span.tip");
        tip.append(
          "<div class='toolTipWrapper'>"
            + "<div class='toolTipLeft'></div>"
            + "<div class='toolTipMid'>"
            + "<img src=" + $(this).parent().find("img").attr("src") + " width='60' height='60'/>"
            + "<span>"
            + "<h5>" + tip.attr("artist_name") + "</h5>"
            + "<div>" + tip.attr("album_name") + "</div>"
            + "<div>" + tip.attr("album_year") + "</div>"
            + "<div>" + tip.attr("artist_label") + "</div>"
            + "</span>"
            + "</div>"
            + "<div class='toolTipRight'></div>"
          + "</div>"
        );
        this.width = $(this).width();
        $(this).parent().find(".toolTipWrapper").css({left:this.width-29});
        $(".toolTipWrapper").fadeIn(300);
      },
      function()
      {
        $(".toolTipWrapper").fadeOut(100);
        $(this).parent().find("span.tip").children().remove();
      });
  });

  $("form#artist_search").submit(function(e) {
    $('#results').html("");
    artist_name = $("#name").val();
    $.ajax({
      type: "GET",
      url: "/artists",
      data: {name: artist_name, appending: (cancelMode == "playlistSave" ? 1 : 0) },
      beforeSend: function(error)
      {
        $("#loader").show();
      },
      error: function(error)
      {
        alert("Error: " + error);
      },
      success: function(response, status)
      {
        $("#loader").hide();
        $("#results").show();
        if(response != " ")
        {
          $('#results').html(response);
        }
        else
        {
          $('#results').html('<p class="error" style="margin: 10px;">' + artist_not_found  + "</p>");
          return false;
        }
        if(cancelMode != "playlistSave") cancelMode = "search";
        $("#cancel_creation").show();
      }
    })
    e.stopPropagation();
    return false;
  });

  $("#new_playlist").livequery("focus", function(e)
  {
    $(this).attr("value", "");
  });

  $("td a.add").livequery("click", function(e)
  {
    songObj.id = this.id;
    songObj.artist = $.trim($(this).parent().parent().parent().parent().parent().find(".artist_name span a").text());
    songObj.songName = $.trim($(this).parent().parent().find(".song").text());
    songObj.duration = $.trim($(this).parent().parent().find(".duration_time").text());
    songObj.sec = $.trim($(this).parent().parent().find(".duration").attr("sec"));
    $("#save_options").show();
    $("#save_options h3 span").html("\""+songObj.songName+"\"");
    $("#cancel_creation").show();
    cancelMode = "playlistCreation";
    if(!playlistLoaded) loadPlaylists();
    return false;
  });

  $("td a.append").livequery("click", function(e)
  {
    if($("#playlist_results table tbody tr[id=" + this.id + "]").attr("id") == undefined)
    {
      songObj.id = this.id;
      songObj.artist = $.trim($(this).parent().parent().parent().parent().parent().find(".artist_name span a").text());
      songObj.songName = $.trim($(this).parent().parent().find(".song").text());
      songObj.duration = $.trim($(this).parent().parent().find(".duration_time").text());
      songObj.sec = $.trim($(this).parent().parent().find(".duration").attr("sec"));
      appendItem(songObj);
    }
    else
    {
      $("#playlist_results table tbody tr[id=" + this.id + "]").css("background-color", "#FFFFCC");
      $("#playlist_results table tbody tr[id=" + this.id + "]").animate({ backgroundColor: "#FFFFFF" }, 1500 );
    }

    return false;
  });

  $("td a.delete").livequery("click", function(e)
  {
    removeItem(this.id, this);
    return false;
  });

  $("#cancel_creation a.cancel").livequery("click", function(e)
  {
    resetLogic();
  });

  $("div#playlist_options input").livequery("click", function(e)
  {
    if(destroyIds.length > 0)
    {
      destroySongs();
    }
    else
    {
      savePlaylist();
    }
    return false;
  });

  $("div.create_new div.create_actions input").livequery("click", function(e)
  {
    newPlaylistName = $("#new_playlist").attr("value");
    newPlaylist = 1;
    loadPlaylist(0);
    return false;
  });

  $("#playlists").change(function()
  {
    loadPlaylist(this.value);
  });

  $('.what_listen').livequery('click', function(e) {
      var filter_idx = $("#activity_type_filters").children('li').index($("#activity_type_filters li a.active").parent("li"));
      if(filter_idx == 0 || filter_idx == 1)
      {
        appendSongToActivity($(this).attr('id'));
      }
      else
      {
        listen_id = this.attr('id');
				console.log('listen_id: ' + listen_id);
        switch_activity($("#activity_type_filters li:eq(0) a"));
      }
      return false;
  });

  /////////////////////////////////////////////////////

});

/////////////////////////////////////////////////////
// WHAT DO YOU WANT TO LISTEN TO LOGIC AND METHODS //
/////////////////////////////////////////////////////

var songObj = {};
var songIds = [];
var destroyIds = [];
var playlistIds = [];
var newPlaylistName = "";
var newPlaylist = 0;
var playlistLoaded = false;
var cancelMode;

function loadPlaylists()
{
  $.ajax(
  {
    type: "GET",
    url: "/my/playlists.xml",
    success: function(xml, status)
    {
      var options = "";
      options += "<option>" + select_playlist + "</option>";
      $(xml).find("list").each(function()
      {
        options += "<option value='" + $(this).find("idpl").text() + "'>" + $(this).find("nom").text() + "</option>"
      });
      $("#playlists").html(options);
      playlistLoaded = true;
    },
    error: function()
    {
      alert("ERROR");
    }
  });
}

function loadPlaylist(id)
{
  $("div#save_options").hide();
  playlistIds = id;
  $.ajax(
  {
    type: "GET",
    url: "/my/playlists/" + id + ".html",
    beforeSend: function(e)
    {
      $("div#loader").show();
    },
    success: function(response, status)
    {
      for(var i = 0; i < $("#results table tbody").children().length; i++)
      {
        $("#results table tbody tr:eq(" + i + ") td:eq(3) a").attr("class", "append");
        $("#results table tbody tr:eq(" + i + ") td:eq(3) img").attr("src", "/images/activity-append.gif");
      }
      $("div#loader").hide();
      $("div#playlist_results").show();
      $("div#playlist_results").html(response);
      if(id == 0)
      {
       $("div#playlist_result span.result_title").html(newPlaylistName);
      }
      $("div#playlist_options").show();
      cancelMode = "playlistSave";

      if($("#playlist_results table tbody tr[id=" + songObj.id + "]").attr("id") == undefined)
      {
        if(songObj.id != undefined) appendItem(songObj);
      }
      else
      {
        $("#playlist_results table tbody tr[id=" + songObj.id + "]").css("background-color", "#FFFFCC");
        $("#playlist_results table tbody tr[id=" + songObj.id + "]").animate({ backgroundColor: "#FFFFFF" }, 1500 );
        calculateMeta();
      }
    },
    error: function()
    {
      alert("ERROR");
    }
  });
}

var listen_id;
function appendSongToActivity(id)
{
  $.ajax({
    type: "GET",
    url: "/activity/activity/listen/" + id,
    error: function() {
      //alert("Error!");
    },
    success: function(response, status) {
      if(response != "") {
        $('.activities').prepend(response);
        li = $('.activities :first');
        track_switch(li);
        setTimeout("toggle_player(li)", 500);
      }
      if(cancelMode != "playlistSave" && cancelMode != "playlistCreation")
      {
        $("#results").hide();
        $("#cancel_creation").hide();
      }
    }
  })
}

function appendItem(data)
{
  songIds.push(data.id);
  var item_template  = "<tr id=" + data.id + ">";
      item_template += "<td class='name'>" + data.songName + "</td>";
      item_template += "<td class='artist'>" + data.artist + "</td>";
      item_template += "<td class='duration' sec='" + data.sec + "'>" + (data.duration == "" ? "<a class='facebox sample_flag' href='/support/sample_flag_desc'/>" : data.duration) + "</td>";
      item_template += "<td><a href='#' title='delete' class='delete' id='" + data.id + "'><img src='/images/activity-delete.gif'/></a></td>";
      item_template += "</tr>";
  $("#playlist_results table tbody").prepend(item_template);

  calculateMeta();

  $("#playlist_results table tbody tr[id=" + data.id + "]").css("background-color", "#FFFFCC");
  $("#playlist_results table tbody tr[id=" + data.id + "]").animate({ backgroundColor: "#FFFFFF" }, 1500 );
}

function removeItem(id, element)
{
  var itemFound = false;
  for(var i = 0; i < songIds.length; i++)
  {
    if(songIds[i] == id)
    {
      songIds.splice(i, 1);
      itemFound = true;
      break;
    }
  }
  $(element).parent().parent().remove();
  if(!itemFound) destroyIds.push(id);
  calculateMeta();
}

Array.prototype.sum = function()
{
  return (! this.length) ? 0 : this.slice(1).sum() +
      ((typeof this[0] == "number") ? this[0] : 0)
};

function calculateMeta()
{
  var playlistCount = $("#playlist_results table tbody").children().length;
  $("#playlist_result span.songs span.count").html(playlistCount);

  var playlistDuration = $("#playlist_results table tbody").children().map(function()
  {
    return Number($(this).find(".duration").attr('sec'));
  }).get().sum();

  $("#playlist_result span.time span.count").html(getHours(playlistDuration) + ":" + getMinutes(playlistDuration) + ":" + getSeconds(playlistDuration));
}

function getHours(s)
{
  return Math.floor(s / 3600) <= 9 ? ("0" + Math.floor(s / 3600))
                                  : Math.floor(s / 3600);
}

function getMinutes(s)
{
  var hoursToMinutes = getHours(s) * 60;
  return Math.floor((s / 60) - hoursToMinutes) <= 9 ? ("0" + Math.floor((s / 60) - hoursToMinutes))
                                                    : Math.floor((s / 60) - hoursToMinutes);
}

function getSeconds(s)
{
  return Math.floor(s % 60) <= 9 ? ("0" + Math.floor(s % 60))
                                 : Math.floor(s % 60);
}

function savePlaylist()
{
  var query = "playlist_ids[]=" + playlistIds;
  query += "&new_playlist_name=" + newPlaylistName;
  if(newPlaylist == 1)
  {
    playlistLoaded = false;
    query += "&new_playlist=1";
  }
  for(var i = 0; i < songIds.length; i++)
  {
    query += "&song_ids[]=" + songIds[i];
  }

  $.ajax(
  {
    type: "POST",
    url: "/my/playlist_items",
    data: query,
    success: function(response, status)
    {
      resetLogic();
      $("#results").hide();
      showConfirmation();
    },
    error: function()
    {
      alert("ERROR");
    }
  });

}

function destroySongs()
{
  for(var i = 0; i < destroyIds.length; i++)
  {
    if(i == 0)
    {
      query = "ids[]=" + destroyIds[i];
    }
    else
    {
      query += "&ids[]=" + destroyIds[i];
    }
  }

  $.ajax(
  {
    type: "DELETE",
    url: "/my/playlists/" + playlistIds + "/items/0",
    data: query,
    success: function(response, status)
    {
      if(songIds.length > 0)
      {
        savePlaylist();
      }
      else
      {
        resetLogic();
        showConfirmation();
      }
    },
    error: function()
    {
      alert("ERROR");
    }
  });

}

function resetLogic()
{
  if(cancelMode == "playlistCreation")
  {
    $("#save_options").hide();
  }
  else if(cancelMode == "search")
  {
    $("#results").hide();
  }
  else if(cancelMode == "playlistSave")
  {
    var default_text = $("#new_playlist").attr("default");
    $("#new_playlist").attr("value", default_text);
    $("div#playlist_results").hide();
    $("div#playlist_options").hide();
    $("#playlists").val("'" + select_playlist + "'");
    for(var i = 0; i < $("#results table tbody").children().length; i++)
    {
      $("#results table tbody tr:eq(" + i + ") td:eq(3) a").attr("class", "add");
      $("#results table tbody tr:eq(" + i + ") td:eq(3) img").attr("src", "/images/activity-add.gif");
    }
  }

  //RESET DEFAULTS
  songObj = {};
  songIds = [];
  playlistIds = [];
  destroyIds = [];
  newPlaylistName = "";
  newPlaylist = 0;
  cancelMode = "";

  $("#cancel_creation").hide();
}

function showConfirmation()
{
  $("#confirmation_alert").show();
  setTimeout("fadeoutConfirmation()", 3000);
}

function fadeoutConfirmation()
{
  $("#confirmation_alert").fadeOut("slow");
}

/////////////////////////////////////////////////////

