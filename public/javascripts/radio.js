jQuery(document).ready(function($){

  $('#create_station_form form').submit(function(e)
  {
    e.preventDefault();
    createStation($(this).find('#station_name').attr('value'));
  });

  if(station_obj.type != undefined) setTimeout("start_player()", 2000);

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

function load_artist_info(artist_id)
{
  $('.artist_radio_info').fadeOut("fast", function(){
    if(artist_id){
      $.ajax({
        type: "POST",
        url: "/radio/info/" + artist_id,
        error: function() 
        {
          alert("error!");
        },
        success: function(response, status) 
        {
          $('.artist_radio_info').html(response);
          if(response.indexOf("<") > -1) $('.artist_radio_info').fadeIn("fast");
        }
      });
    }
  });
}
