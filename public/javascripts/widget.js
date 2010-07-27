var swf = function(objname)
{
  if(navigator.appName.indexOf("Microsoft") != -1)
    return window[objname];
  else
    return document[objname];
};

String.prototype.cleanupURL = function(regex, sub) {
  var cleanup = this.replace(regex, sub);
  cleanup = cleanup.replace(/&&/g, "&");
  cleanup = cleanup.replace(/\?&/g, "?");
  return cleanup;
}
var BANNERS = {};
var Widget = {

  init_top_buttons: function()
  {
    // STATIC MAPPINGS OF BANNER SRC
    var regex = new RegExp(/v_folder=|v_songgenre=|v_songlabel=/g);
    BANNERS.right = {elem: $("#square_banner"), src: String( $("#square_banner").attr("src") ).cleanupURL(regex, "")};
    BANNERS.big = {elem: $("#large_banner"), src: String( $("#large_banner").attr("src") ).cleanupURL(regex, "")};

    // MY STATION LOGIC
    $("#my_stations_button").click(function()
    {
      var value = parseInt( $("#my_stations_toggle").get(0).value, 10 );
      var msn_value = parseInt($("#msn_stations_toggle").get(0).value, 10);
      var create_station_value = parseInt( $("#create_station_toggle").get(0).value, 10 );
      if(value)
      {
        toggleButton("my_stations", 0);
        if(create_station_value) toggleButton("create_station", 0);
        if(msn_value) toggleButton('msn_stations', 0, null);
        $("#now_playing_button").removeClass("custom_button").addClass("grey_button_big");
      }
      else
      {
        toggleButton("my_stations", 1);
        if(create_station_value) toggleButton("create_station", 0);
        if(msn_value) { toggleButton('msn_stations', 0, null); }
        $("#now_playing_button").removeClass("grey_button_big").addClass("custom_button");
      }
      return false;
    });

    $("#msn_stations_button").click(function() {
      value = parseInt($("#msn_stations_toggle").get(0).value, 10);
      my_value = parseInt($("#my_stations_toggle").get(0).value, 10);
      create_station_value = parseInt($("#create_station_toggle").get(0).value, 10);
      if(value) 
      {
        if(my_value) toggleButton("my_stations", 0, null);
        if(create_station_value) toggleButton("create_station", 0, null);
        toggleButton("msn_stations", 0);
        $("#now_playing_button").removeClass("custom_button").addClass("grey_button_big");
      }
      else
      {
        if(my_value) toggleButton("my_stations", 0, null);
        if(create_station_value) toggleButton("create_station", 0, null);
        toggleButton("msn_stations", 1);
        $('#now_playing_button').removeClass("grey_button_big").addClass("custom_button");
      }
      return false;
    });

    // NOW PLAYING LOGIC
    $("#now_playing_button").click(function()
    {
      var my_value = parseInt( $("#my_stations_toggle").get(0).value, 10 );
      var msn_value = parseInt($("#msn_stations_toggle").get(0).value, 10);
      if(my_value || msn_value)
      {
        toggleButton("my_stations", 0);
        toggleButton("msn_stations", 0);
        $("#now_playing_button").removeClass("custom_button").addClass("grey_button_big");
      }
      return false;
    });

    $("#collapse_create_new_station").click(function()
    {
        toggleButton("create_station", 0, toggleCreateStation);
        $("#now_playing_button").removeClass("custom_button").addClass("grey_button_big");
        return false;
    });

    var elems = "div.songs_box ul li a.launch_station";
    $(elems).click(function(e){
      Widget.launch_station_handler(this, e);
    });

    initCreateStationButton();
  },

  set_station_search_details: function(id, queue, play, host)
  {
    $("#create_station_submit").attr('station_id', id);
    $("#create_station_submit").attr('station_queue', queue);
    if(play || typeof(play)=='undefined') { Widget.set_station_details(id, queue, play, host); }
  },

  set_station_details: function(id, queue, play, host)
  {
    $("#station_id").val(id);
    $("#station_queue").val(queue);
    if(play || typeof(play)=='undefined') { Widget.play_station(false, false, null, null, host); }
  },

  launch_station_handler: function(obj, e, host)
  {
    e.preventDefault();
    var is_station_list_item     = $(obj).hasClass("launch_station");
    var is_create_station_submit = $(obj).attr("id") == "create_station_submit";
    var list;
    var list_play_button, show_loading;
    if(is_station_list_item)
    {
      list = obj.id.match(/(.*)_list/)[1];
      if(show_loading)
      {
        var li = $(obj).parentsUntil("li");
        list_play_button = li.find("img.list_play_button");
        if(list_play_button) list_play_button.attr("src", HOSTURL + "/images/grey_loading.gif");
      }
    }
    //if(is_create_station_submit) $(obj).html(Base.layout.spanned_spin_image());
    Widget.set_station_details($(obj).attr('station_id'), $(obj).attr('station_queue'), false, host);
    Widget.play_station(is_station_list_item, is_create_station_submit, list, list_play_button, host)
  },

  play_station: function(from_list, from_create_station, list, list_play_button, host)
  {
    var id       = $('#station_id').val();
    var queue    = $('#station_queue').val();
    var is_owner = $('#owner').val() == "true";
    var req      = HOSTURL + "/widget/album_detail?widget=true&station_id=" + id;

    if(from_list)
    {
      if(list_play_button) { list_play_button.attr('src', HOSTURL + "/images/icon_20_play.png"); }
      toggleButton(list, 0);
    }

    if(from_create_station)
    {
      $("#collapse_create_new_station").click();
      $("#create_station_submit").attr("station_id", "").attr("station_queue", "").removeClass("custom_button").addClass("grey_button_big");
      $("input[name='search_station_name']").val("").blur();
    }
    swf("cyloop_radio").queueStation(id, queue);
    swf("swfutils").proxyreq(req, "album_details");
  },

  remove_from_layer: function(station_id)
  {
    $("#station_to_delete").attr("value", station_id);
    $.popup(function() {
        url = HOSTURL + "/stations/" + station_id + "/delete_widget_station_confirmation";
        swf("swfutils").proxyreq(url, "remove_confirmation");
    });
  },

  init_delete_layer: function() {
    $("#delete_station_button").click(function() {
      var station_id = parseInt( $("#station_to_delete").val(), 10 );
      if(station_id > 0)
      {
        $(document).trigger("close.facebox");
        $("#staiton_to_delete").attr("value", 0);
        $("#my_station_item_" + station_id).slideUp("fast");
        swf("swfutils").connect("my_stations", "delete_object_item");
      }
      return false;
    });
  },

  launch_edit_layer: function(station_id)
  {
    $.popup(function() {
        $.popup( edit_station_layer(stationList[station_id].editobj) );
    });
    return false;
  },

  edit_from_layer: function()
  {
    swf("swfutils").connect("my_stations", "edit_station");
  },

  artist_info: function(id, host)
  {
    var station_id = $('#station_id').val();
    var urlString  = HOSTURL + "/widget/info/" + station_id + "/" + id;
    if( typeof(cutsomKeys) == "string" ) urlString += "?customize=" + customKeys;
    $('.artist_radio_info').slideUp( function() {
      if(id) swf('swfutils').proxyreq(urlString, 'artist_detail');
    });
  },

  reload_list: function(data)
  {
    $("#my_stations_list .songs_box ul").empty();
    for(item in data)
    {
      $("#my_stations_list .songs_box ul").append( setElement(data[item]) );
    }
    $("div#my_stations_list .songs_box ul li a.launch_station").click(function(e){
      e.preventDefault();
      var is_station_list_item = $(this).hasClass("launch_station");
      var is_create_station_submit = $(this).attr("id") == "create_station_submit";
      var list;
      var list_play_button;
      if(is_station_list_item)
      {
        var li = $(this).parentsUntil("li");
        list = this.id.match(/(.*)_list(.*)/)[1];
        list_play_button = li.find("img.list_play_button");
        if(list_play_button) list_play_button.attr('src', HOSTURL + "/images/grey_loading.gif");
      }
      Widget.set_station_details( $(this).attr("station_id"), $(this).attr("station_queue"), false);
      Widget.play_station(is_station_list_item, is_create_station_submit, list, list_play_button, "");
    });
  },

  refreshBanner: function(attr)
  {
    for(key in BANNERS)
    {
      BANNERS[key].elem.attr("src", BANNERS[key].src + attr);
    }
  }

};

function remove_confirmation(data)
{
  $.popup(data);
}

function edit_station_layer(data)
{
  var elem  = "<form action='' method='post' class='account_settings edit_station_form'>";
      elem += "<input id='layer_station_id' type='hidden' value='" + data.id + "'/>";
      elem += "<div class='title' style='float:left'>" + data.title + "</div>";
      elem += "<div id='edit_loading' style='float:right' class='hide'>";
      elem += "<img src='/images/loading.gif' />";
      elem += "</div>";
      elem += "<br class='clearer'/>";
      elem += "<div class='form_row'>";
      elem += data.stationimg;
      elem += "<div class='popup_mix_text'>";
      elem += "<big>" + data.name + "</big><br/>";
      elem += "<small>" + data.includes + "</small>";
      elem += "</div>";
      elem += "<div class='clearer'></div>";
      elem += "<br/>";
      elem += "</div>";
      elem += "<div class='form_row'>";
      elem += "<label><b>" + data.newname + "</b></label>";
      elem += "<div class='grey_round_box'>";
      elem += "<input id='new_station_name' type='text' class='input full_width' />";
      elem += "</div>";
      elem += "</div>";
      elem += "<br/>";
      elem += "<div class='align_right'>";
      elem += "<big<a href='#' class='black valign_middle popup_close_action' onclick=\"$(document).trigger('close.facebox');return false;\">Cancel</a></big>";
      elem += "<a href='#' onclick='Widget.edit_from_layer(); return false;' id='save_station_name_button' class='custom_button valign_middle'><span><span>Save</span></span></a>";
      elem += "</div>";
      elem += "</form>";
  return elem;
}

function edit_station(items)
{
  var station_id = $("#layer_station_id").val();
  var new_station_name = $("#new_station_name").val();

  if(new_station_name == '') { alert("Blank"); return false; }

  items[station_id].editobj.name = new_station_name;
  var stations = items;
  swf("swfutils").store("my_stations", stations);

  $("#my_stations_list_name_" + station_id).html(new_station_name);

  if(station_id == currentStation.id) { 
    $("#station_title").html(new_station_name); 
  }
  $(document).trigger("close.facebox");
}

function delete_object_item(items)
{
  delete items[parseInt( $("#station_to_delete").val(), 10 )];
  var stations = items;
  swf("swfutils").store("my_stations", stations);
}


function edit_station_layer(data)
{
  var elem  = "<form action='' method='post' class='account_settings edit_station_form'>";
      elem += "<input id='layer_station_id' type='hidden' value='" + data.id + "'/>";
      elem += "<div class='title' style='float:left'>" + data.title + "</div>";
      elem += "<div id='edit_loading' style='float:right' class='hide'>";
      elem += "<img src='/images/loading.gif' />";
      elem += "</div>";
      elem += "<br class='clearer'/>";
      elem += "<div class='form_row'>";
      elem += data.stationimg;
      elem += "<div class='popup_mix_text'>";
      elem += "<big>" + data.name + "</big><br/>";
      elem += "<small>" + data.includes + "</small>";
      elem += "</div>";
      elem += "<div class='clearer'></div>";
      elem += "<br/>";
      elem += "</div>";
      elem += "<div class='form_row'>";
      elem += "<label><b>" + data.newname + "</b></label>";
      elem += "<div class='grey_round_box'>";
      elem += "<input id='new_station_name' type='text' class='input full_width' />";
      elem += "</div>";
      elem += "</div>";
      elem += "<br/>";
      elem += "<div class='align_right'>";
      elem += "<big<a href='#' class='black valign_middle popup_close_action' onclick=\"$(document).trigger('close.facebox');return false;\">Cancel</a></big>";
      elem += "<a href='#' onclick='Widget.edit_from_layer(); return false;' id='save_station_name_button' class='custom_button valign_middle'><span><span>Save</span></span></a>";
      elem += "</div>";
      elem += "</form>";
  return elem;
}

function edit_station(items)
{
  var station_id = $("#layer_station_id").val();
  var new_station_name = $("#new_station_name").val();

  if(new_station_name == '') { alert("Blank"); return false; }

  items[station_id].editobj.name = new_station_name;
  var stations = items;
  swf("swfutils").store("my_stations", stations);

  $("#my_stations_list_name_" + station_id).html(new_station_name);

  if(station_id == currentStation.id) { 
    $("#station_title").html(new_station_name); 
  }
  $(document).trigger("close.facebox");
}

function delete_object_item(items)
{
  delete items[parseInt( $("#station_to_delete").val(), 10 )];
  var stations = items;
  swf("swfutils").store("my_stations", stations);
}

function initCreateStationButton()
{
  $("#search_station_name").trigger("blur");
  $("#create_station_button").click(function() {
      var value    = parseInt( $("#create_station_toggle").get(0).value, 10 );
      var my_value = parseInt( $("#my_stations_toggle").get(0).value, 10 );
      if(value)
      {
        if(my_value) toggleButton("my_stations", 0);
        $("#now_playing_button").removeClass("custom_button").addClass("grey_button_big");
        toggleButton("create_station", 0, toggleCreateStation);
      }
      else
      {
        if(my_value) toggleButton("my_stations", 0);
        $("#now_playing_button").removeClass("grey_button_big").addClass("custom_button");
        toggleButton("create_station", 1, toggleCreateStation);
      }
      return false;
  });
}

function toggleCreateStation(show)
{
  if(show)
  {
    $("#current_station_info").addClass("hide");
    $("#create_new_station_form").removeClass("hide");
  }
  else
  {
    $("#create_new_station_form").addClass("hide");
    $("#current_station_info").removeClass("hide");
  }
}

function artist_detail(result)
{
  $('.artist_radio_info').html(result);
  if(result.indexOf('<') > -1) $('.artist_radio_info').show();
}

function album_details(result)
{
  $('#current_station_info').empty();
  $('#current_station_info').append(result);
  $('#current_station_info').append("<div class='clearer'></div>");
  initCreateStationButton();
}

function toggleButton(button, show, callback)
{
  if(show)
  {
    $("#" + button + "_toggle").attr("value", "1");
    $("#" + button + "_button").removeClass("custom_button").addClass("grey_button_big");
    $("#" + button + "_list").removeClass("hide");
  }
  else
  {
    $("#" + button + "_toggle").attr("value", "0");
    $("#" + button + "_button").removeClass("grey_button_big").addClass("custom_button");
    $("#" + button + "_list").addClass("hide");
  }

  if(typeof(callback) == "function") callback(show);
}

function toggleButton(button, show, callback)
{
  if(show)
  {
    $("#" + button + "_toggle").attr("value", "1");
    $("#" + button + "_button").removeClass("custom_button").addClass("grey_button_big");
    $("#" + button + "_list").removeClass("hide");
  }
  else
  {
    $("#" + button + "_toggle").attr("value", "0");
    $("#" + button + "_button").removeClass("grey_button_big").addClass("custom_button");
    $("#" + button + "_list").addClass("hide");
  }
  if(typeof(callback) == "function") callback(show);
}

