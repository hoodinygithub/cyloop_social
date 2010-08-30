jQuery(document).ready(function($){

  $('#create_station_form form').submit(function(e)
  {
    e.preventDefault();
    createStation($(this).find('#station_name').attr('value'));
  });

  if(typeof station_obj != "undefined" && station_obj.type != undefined) setTimeout("start_player()", 2000);

});

var station_obj = {};

function swfReady()
{
  if(station_obj.type != undefined) start_player();
}

function start_player()
{
  flash_object("radio_engine").add_station(station_obj); 
}

function playStation(id)
{
  $.ajax({
    url:      "/radio/play",
    type:     "post",
    data:     {station_id: id, authenticity_token: encodeURIComponent(AUTH_TOKEN)},
    dataType: "xml",
    success:  function(xml)
    {
      var mainNode = flashvars.LOGGEDIN == "true" ? 'user-station' : 'station';
      var obj = $(xml);

      if(obj.find(mainNode).size() == 0) 
      {
        //TODO: PREPEND DOESN'T SEEM TO BE WORKING. REVIEW!!
        if ($('#page_wrapper').find("#messages .error").size() > 0)
        {
          $("#messages .error").text(obj);
        }
        else 
        {
          error_message = "<div id='messages'><p class='error'>broken</p></div>";
          $(error_message).prependTo('#page_wrapper');
        }
      }
      else
      {
        var station_name, station_idpl, station_url, station_id;
        if(flashvars.LOGGEDIN == 'true')
        {
          station_name = obj.find('user-station name:eq(0)').text();
          station_idpl = obj.find('user-station station-id').text();
          station_url  = obj.find('user-station station-url').text();
          station_id   = obj.find('user-station id:eq(0)').text();
        }
        else
        {
          station_name = obj.find('station name:eq(0)').text();
          station_idpl = obj.find('station id:eq(0)').text();
          station_url  = obj.find('station station-url').text();
          station_id   = obj.find('station id:eq(0)').text();
        }
        addNewStation(station_name, station_idpl, station_url, station_id);
      }
    },
    error: function(e)
     {
       alert('ERROR OCCURRED: ' + e);
     }
  });
}

function createStation(station_name)
{
  $.ajax({
    url:      "/radio/search",
    type:     "post",
    data:     {station_name: station_name, authenticity_token: encodeURIComponent(AUTH_TOKEN)},
    dataType: "xml",
    success:  function(xml)
    {
      var mainNode = flashvars.LOGGEDIN == "true" ? 'user-station' : 'station';
      var obj = $(xml);

      if(obj.find(mainNode).size() == 0) 
      {
        //TODO: PREPEND DOESN'T SEEM TO BE WORKING. REVIEW!!
        if ($('#page_wrapper').find("#messages .error").size() > 0) 
        {
          $("#messages .error").text(obj);
        }
        else 
        {
          error_message = "<div id='messages'><p class='error'>broken</p></div>";
          $(error_message).prependTo('#page_wrapper');
        }
      }
      else
      {
        var station_name, station_idpl, station_url, station_id;
        if(flashvars.LOGGEDIN == 'true')
        {
          station_name = obj.find('user-station name:eq(0)').text();
          station_idpl = obj.find('user-station station-id').text();
          station_url  = obj.find('user-station station-url').text();
          station_id   = obj.find('user-station id:eq(0)').text();
        }
        else
        {
          station_name = obj.find('station name:eq(0)').text();
          station_idpl = obj.find('station id:eq(0)').text();
          station_url  = obj.find('station station-url').text();
          station_id   = obj.find('station id:eq(0)').text();
        }
        addNewStation(station_name, station_idpl, station_url, station_id);
      }
    },
    error: function(e)
     {
       alert('ERROR OCCURRED: ' + e);
     }
  });
}

function addNewStation(station_name, station_idpl, station_url, station_id)
{
  station_obj = {type:'99', station_url:station_url, idpl: station_idpl, nom:station_name, id:station_id}
  flash_object("radio_engine").add_station(station_obj);
}

function initArtistInfo() {
  $('.tabs > div').hide();
  $('.tabs > div:first').show(); // Show first div
  $('.tabs ul li:first').addClass('active'); // Set the class of the first link to active
  $('.tabs ul li a').click(function() {
    $('.tabs ul li').removeClass('active');
    $(this).parent().addClass('active');
  
    var currentTab = $(this).attr('href').match(/#.*/)[0];
    
    $('.tabs > div').hide();
    $(currentTab).show();
    return false;
  });
}

function initRadioTabs() {
	$(".radio_tabs a").click(function() {
     value = this.id.match(/radio_(.*)_tab/)[1];
     $('#radio_tab_scope').attr('value', value);      
		 toggleRadioTabs();
     return false;
  });
}

function toggleRadioTabs() {
	value = $("#radio_tab_scope").get(0).value;
  $(".radio_tabs a").each(function(el) {
    if(this.id != "radio_" + value + "_tab") {
			$(this).removeClass('active');
		}
  });
	$("#radio_" + value + "_tab").addClass('active');

  $(".radio_tabs_content").each(function(el) {
    if(this.id != value + "_content") {
    	$(this).addClass('hide');
		}
  });
	$("#" + value + "_content").removeClass('hide');
	
}

function toggleCreateStation(show) {
	if(show) {
		$('#current_station_info').addClass('hide');
		$('#create_new_station_form').removeClass('hide');
	} else {
		$('#create_new_station_form').addClass('hide');
		$('#current_station_info').removeClass('hide');
	}
}

function toggleButton(button, show, callback) {
	if(show) {
		$('#' + button + '_toggle').attr('value', "1");      
		$('#' + button + '_button').removeClass('custom_button').addClass('grey_button_big');
		$('#' + button + '_list').removeClass('hide');
	} else {
		$('#' + button + '_toggle').attr('value', "0");      
		$('#' + button + '_button').removeClass('grey_button_big').addClass('custom_button');
		$('#' + button + '_list').addClass('hide');
	}
	if (typeof(callback)=="function") {		
		callback(show);
	}
}

function initTopButtons() {
  $("#my_stations_button").click(function() {
		value = parseInt($("#my_stations_toggle").get(0).value, 10);
		msn_value = parseInt($("#msn_stations_toggle").get(0).value, 10);
		create_station_value = parseInt($("#create_station_toggle").get(0).value, 10);

		if(value) {
			if(msn_value) { toggleButton('msn_stations', 0, null); }
			if(create_station_value) { toggleButton('create_station', 0); }
			toggleButton('my_stations', 0);
			$('#now_playing_button').removeClass('custom_button').addClass('grey_button_big');			
		} else {
			if(msn_value) { toggleButton('msn_stations', 0, null); }
			if(create_station_value) { toggleButton('create_station', 0); }
			toggleButton('my_stations', 1);
			$('#now_playing_button').removeClass('grey_button_big').addClass('custom_button');			
		}			
    return false;
  });	

  $("#msn_stations_button").click(function() {
		value = parseInt($("#msn_stations_toggle").get(0).value, 10);
		my_value = parseInt($("#my_stations_toggle").get(0).value, 10);
		create_station_value = parseInt($("#create_station_toggle").get(0).value, 10);
		
		if(value) {
			if(my_value) { toggleButton('my_stations', 0, null);}
			if(create_station_value) { toggleButton('create_station', 0, null); }
			toggleButton('msn_stations', 0);
			$('#now_playing_button').removeClass('custom_button').addClass('grey_button_big');			
		} else {
			if(my_value) { toggleButton('my_stations', 0, null); }
			if(create_station_value) { toggleButton('create_station', 0, null); }
			toggleButton('msn_stations', 1);
			$('#now_playing_button').removeClass('grey_button_big').addClass('custom_button');			
		}			
    return false;
  });	
	
  $("#collapse_create_new_station").click(function() {
		toggleButton('create_station', 0, toggleCreateStation);
		$('#now_playing_button').removeClass('custom_button').addClass('grey_button_big');			
    return false;
  });	

	initCreateStationButton();

  $("#now_playing_button").click(function() {
		msn_value = parseInt($("#msn_stations_toggle").get(0).value, 10);
		my_value = parseInt($("#my_stations_toggle").get(0).value, 10);

		if(msn_value || my_value) {
			toggleButton('msn_stations', 0);
			toggleButton('my_stations', 0);			
			$('#now_playing_button').removeClass('custom_button').addClass('grey_button_big');			
		}
    return false;
    });	
	}

function initCreateStationButton() {
	$("#search_station_name").trigger('blur');
	$("#create_station_button").click(function() {
		value = parseInt($("#create_station_toggle").get(0).value, 10);
		my_value = parseInt($("#my_stations_toggle").get(0).value, 10);
		msn_value = parseInt($("#msn_stations_toggle").get(0).value, 10);

		if(value) {
			if(my_value) { toggleButton('my_stations', 0);}
			if(msn_value) { toggleButton('msn_stations', 0); }
			toggleButton('create_station', 0, toggleCreateStation);
			$('#now_playing_button').removeClass('custom_button').addClass('grey_button_big');			
		} else {
			if(my_value) { toggleButton('my_stations', 0); }
			if(msn_value) { toggleButton('msn_stations', 0); }
			toggleButton('create_station', 1, toggleCreateStation);
			$('#now_playing_button').removeClass('grey_button_big').addClass('custom_button');
		}			
    return false;
	});
}

function load_artist_info(artist_id) {
  station_id = $('#station_id').val() 
  var urlString = "/radio/info/" + station_id + "/" + artist_id;
  if( typeof(customKeys) == "string" ) urlString += "?customize=" + customKeys;
  if(window.location.pathname == "/hprocks"){
   urlString += "&return_to=/hprocks";
  }
  $('.artist_radio_info').slideUp(function(){
    if(artist_id){
      $.ajax({
        type: "GET",
        url: urlString,
        error: function() 
        {
          alert("error!");
        },
        success: function(response, status) 
        {
          $('.artist_radio_info').html(response);
					initRadioTabs();
          if(response.indexOf("<") > -1){
            //$('.artist_radio_info').slideDown();
            $('.artist_radio_info').show();
          } 
        }
      });
    }
  });
}

function load_station_info(station_id)
{
  $('.artist_radio_info').slideUp(function() {
    if(station_id){
      $.ajax({
        type: "GET",
        url: "/mixes/info/" + station_id,
        error: function()
        {
					load_licensing_message();
        },
        success: function(response, status)
        {
					load_licensing_message();
          $('.artist_radio_info').html(response);
          initRadioTabs();
          $('input[type=radio].star').rating();
          if(response.indexOf("<") > -1) {
	    $('.artist_radio_info').show(); //Can't be slideDown IE problem
	  }
        }
      });
    }
  });
}
