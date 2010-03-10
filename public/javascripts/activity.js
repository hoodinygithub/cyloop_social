(function($) {
	var ActivityFeedSwitcher = function() {
		var filters = new Array('all', 'listen', 'playlist', 'station', 'twitter');
		var currentView;
		var loadTime = (new Date()).getTime();
		
		this.showTime = function() {
			var time = new Date();
			this.loadTime = time.getTime();
			console.log('time: ' + this.loadTime);
		}
	};
	
	$.fn.activityFeedSwitcher = function() {
		return this.each(function() {
			var element = $(this);
			var activityFeedSwitcher = new ActivityFeedSwitcher(this);
			element.data('activityFeedSwitcher', activityFeedSwitcher);
		});
	};
})(jQuery);


var arrActivityFilters = new Array('all', 'listen', 'playlist', 'station', 'twitter');
var activeActivityFilter = 0;
var arrViewFilters = new Array('all', 'me', 'following');
var activeViewFilter = 0;
var _currentActivity;
var _currentView;
var _currentPage = 1;
var _buttonEnabled = false;

jQuery(document).ready(function($){

 activeViewFilter = $("#activity_filters").children('li').index($("#activity_filters li a.active").parent("li"));
 _currentView = $("#activity_filters li:eq(" + activeViewFilter + ") a");
_buttonEnabled = true;
 get_page_activity();

});

function switch_activity(t)
{
	// Default first Tab to active
	if(!_currentActivity)
		_currentActivity = $("#activity_type_filters li:eq(0) a");
	
	$(_currentActivity).removeClass("active");
	$(_currentActivity).parent("li").children("span").removeClass("loading");
	
	$(t).addClass("active");
	$(t).parent("li").children("span").addClass("loading");
	
	_currentActivity = $(t);
	activeActivityFilter = ($("#activity_type_filters").children('li').index($(t).parent('li')));

	_buttonEnabled = true;
	_currentPage = 1;
	get_page_activity();
}

function switch_view(t)
{
	
	$(_currentView).removeClass("active");
	$("#activity_filters li.last").addClass("loading");
	
	$(t).addClass("active");
	
	_currentView = $(t);
	activeViewFilter = ($("#activity_filters").children('li').index($(t).parent('li')));

	_buttonEnabled = true;
	_currentPage = 1;
	
	get_page_activity();
}

function get_page_activity(){
	unload_tracker();
	// active_layer = null; active_layer not null avoid overlap players
	set_player = false;
	
	user = $('.activities').attr("user");
	if(user > 0 && _buttonEnabled)
	{
		$.ajax({
			type: "GET",
			url: "/activity/activity/" + arrActivityFilters[activeActivityFilter],
      data: {
        format: 'js',
        user: user,
        page: _currentPage,
        su: ((arrViewFilters[activeViewFilter] != 'following')?'true':'false'),
        sf: ((arrViewFilters[activeViewFilter] != 'me')?'true':'false')
      },
			error: function() {
				//alert("Error!");
				$(_currentActivity).parent("li").children("span").removeClass("loading");
			},
			success: function(response, status) {
				$(_currentActivity).parent("li").children("span").removeClass("loading");
				if(_currentPage == 1)
					$('.activities').html(response);
				else
					$('.activities').append(response);

				$('#activity .pagination').show();

				$("#activity_filters li.last").removeClass("loading");

				al = $('.activities').children().length
				if( al == 0 || al % 15 )
					disable_more_activity();
				else
					enable_more_activity();
					
				if(listen_id != null)
				{
					appendSongToActivity(listen_id);
					listen_id = null;
				}
			}
		})
	} else {
	  $("#activity_filters li.last").removeClass("loading");
	}
}

function get_more_activity(){
	_currentPage++;
	get_page_activity();
	return false;
}

function enable_more_activity(){
	_buttonEnabled = true;
	$('#activity_more').text(more_activity);
	$('.pagination').show();
}

function disable_more_activity(){
	_buttonEnabled = false;
	$('#activity_more').text(no_more_activity);
	$('.pagination').hide();
}

function activateLayer(t,disable){
	if(disable)
		$(t).removeClass('over');
	else
		$(t).addClass('over');
}
