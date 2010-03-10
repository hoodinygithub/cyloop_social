(function($) {
	var ActivityFeedSwitcher = function() {
		var filters = new Array('all', 'playlist', 'station', 'twitter');
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

// Some Compatibility Issues
if(!Array.indexOf){
  Array.prototype.indexOf = function(obj){
    for(var i=0; i<this.length; i++){
      if(this[i]==obj){
        return i;
      }
    }
    return -1;
  }
}
if(!String.count){
  String.prototype.count=function(s1) { 
  	return (this.length - this.replace(new RegExp(s1,"g"), '').length) / s1.length;
  }
}

(function($) {
  Activity = {
    options: {
      arrActivityFilters: ['all', 'playlist', 'station', 'twitter'],
      activeActivityFilter: 0,
      arrViewFilters: ['all', 'me', 'following'],
      activeViewFilter: 0,
      buttonEnabled: false,
      currentActivity: null,    
      currentView: null,
      currentPage: 1,
      viewsEnabled: true,
      pushTimer: true, 
      pushInterval: 15000, 
      itemsToPush: 0, 
      format: "js",
      justUpdateQty: false,
      pushedTimestamps: []    
    }
  }

  Activity.Feed = function() {
    var self = this;  

    this.enable  = function() { Activity.options.pushTimer = true;  };
    this.disable = function() { Activity.options.pushTimer = false; };
    $(window).bind("blur",  function() { $('#activity').data('activityFeed').disable(); });
    $(window).bind("focus", function() { $('#activity').data('activityFeed').enable();  });

    this.getTimestamp = function(type) {
      if (['first', 'last'].indexOf(type) < 0) { return false; }
      var items = $('.activities li:'+type);
      if(items.length > 0) return parseInt(items.attr("timestamp"));
      return 0;
    }

    this.getItemsToPush = function() { return Activity.options.itemsToPush; };
    this.setItemsToPush = function(qty) { Activity.options.itemsToPush = parseInt(qty); };

    this.getUser = function() {
      var user = $('.activities').attr("user");
      if (user) return parseInt(user);
      return false;
    }
  
    this.pushUrl = function() { 
      currentOptions = Activity.options;
      return "/activity/activity/" + currentOptions.arrActivityFilters[currentOptions.activeActivityFilter]; 
    }
  
    this.getData = function(options) {    
      if (!options) options = {};
      data = {};
      
      currentOptions = Activity.options;
    
      data.su     = ((currentOptions.arrViewFilters[currentOptions.activeViewFilter] != 'following')?'true':'false');
      data.sf     = ((currentOptions.arrViewFilters[currentOptions.activeViewFilter] != 'me')?'true':'false');
      data.page   = options.page || currentOptions.currentPage;
      data.format = options.format || currentOptions.format;
      data.user   = self.getUser();
    
      if (!currentOptions.firstLoad && data.page == 1) {
        if (options.bts) { 
          data.bts = self.getTimestamp("last");
          if (data.bts == 0) data.bts = null;        
        }
        if (options.ats) { 
          data.ats = self.getTimestamp("first");  
          if (data.ats == 0) data.ats = null;
        }        
      }    
      return data;
    }

    this.check = function() {
      if (!Activity.options.pushTimer) { return false; }      
      if (self.getTimestamp("first") == 0) { return false; }
      currentActivity = Activity.options.currentActivity;
      currentView     = Activity.options.currentView;            
      $.getJSON(self.pushUrl(), self.getData({format: "json", ats: true, page: 1}), 
        function(json) {
          if (parseInt(json.items) > 0) {
            options = Activity.options;
            if (currentView == options.currentView && currentActivity == options.currentActivity) {
              self.showPushAlert(json.message);
              self.setItemsToPush(json.items);              
            }
          } else {
            self.hidePushAlert();
            self.setItemsToPush(0);            
          }
        }
      );
    };
  
    this.loading = function(show) {
      currentOptions = Activity.options;
      if (show) {
        $(currentOptions.currentActivity).parent("li").children("span").addClass("loading");
        $("#activity_filters li.last").addClass("loading");
        if (currentOptions.buttonEnabled)
    	    $('#activity_more').html("<span></span>");        
      } else {
        $(currentOptions.currentActivity).parent("li").children("span").removeClass("loading");
        $("#activity_filters li.last").removeClass("loading");      
        $("#loading_more").hide();
        if (currentOptions.buttonEnabled)
    	    $('#activity_more').html(more_activity);
      }
    }
    
    this.enableMore = function(){
    	Activity.options.buttonEnabled = true;
    	$('#activity_more').text(more_activity);
    	$('.pagination').show();
    }

    this.disableMore = function(){
    	Activity.options.buttonEnabled = true;
    	$('#activity_more').text(no_more_activity);
    	$('.pagination').hide();
    }    
    
    this.loadActivity = function() {
      Activity.options.firstLoad = true;
      self.more(function() {
        Activity.options.viewsEnabled = true;
      });
    }
  
    this.isArtist = function() {
      var isArtist = $('.activities').attr("is_artist");
      if (isArtist == "true") return true;
      return false;
    }
    
    this.appendResponse = function(response) {
      if (Activity.options.firstLoad) {
        $('.activities').html(response);
        Activity.options.firstLoad = false;
      } else {
        $('.activities li:last').addClass("last_loaded");
        $('.activities').append(response);            
      }      
      $(this).oneTime("400ms", function() {
        newItems = $('.activities li:last('+response.count("/li")+')');
        newItems.effect("highlight", {}, 800);
      });      
    }
    
    this.page = function() {
      if (self.isArtist())
        return Activity.options.currentPage;
      else
        return 1;
    }
    
    this.moreButtonVisibility = function() {
			al = $('.activities').children().length
			if( al == 0 || al % 15 )
				return self.disableMore();
			else
				return self.enableMore();
    }
  
    this.more = function(afterCallback) {
      timestamp = self.getTimestamp("last");
      self.loading(true);
      $.ajax({
        type: "GET",
        url: self.pushUrl(),
        data: self.getData({bts: true, page: self.page()}),
        error: function() {
          self.loading(false);
          if (afterCallback) { afterCallback(); }
        },
        success: function(response, status) {
          if (self.isArtist()) {
            self.appendResponse(response);
            Activity.options.currentPage++;
            self.moreButtonVisibility();
          } else {
            lastTimestamp = self.getTimestamp("last");
            if ( timestamp == lastTimestamp && Activity.options.pushedTimestamps.indexOf(lastTimestamp) < 0 ) {
              Activity.options.pushedTimestamps.push(lastTimestamp);
              self.appendResponse(response);
              self.moreButtonVisibility();
            } else {
              console.log('Item already pushed: ' + timestamp );
            }            
          }
          if (afterCallback) { afterCallback(); }
          self.loading(false);        
        }
      });    
    }
  
    this.push = function() {
      self.hidePushAlert();
      $.ajax({
        type: "GET",
        url: self.pushUrl(),
        data: self.getData({ats: true, page: 1}),
        error: function() {
          self.loading(false);
        },
        success: function(response, status) {
          timestamp = self.getTimestamp("first");          
          if ( Activity.options.pushedTimestamps.indexOf(timestamp) < 0 ) {
            Activity.options.pushedTimestamps.push(timestamp);
            $('.activities').prepend(response);
            $(this).oneTime("400ms", function() {
              newItems = $('.activities li:lt('+self.getItemsToPush()+')');
              newItems.effect("highlight", {}, 800);
            });
            self.loading(false);
          } else {
            console.log('Item already pushed: ' + timestamp);
          }
        }
      });    
    } 
  
    this.showPushAlert = function(message) {  
      if (self.getTimestamp("first") == 0 || Activity.options.pushedTimestamps.indexOf(self.getTimestamp("first")) < 0 ) {
        $('#push_notification_text').html(message);
        if (!Activity.options.justUpdateQty)
          $('#push_notification').fadeIn('slow');
        $('#push_notification_refresh').bind('click', function() { 
          self.push(); 
          return false; 
        });
        $('#push_notification_close').bind('click', function() { 
          self.hidePushAlert(); 
          return false; 
        });
      }
    }
  
    this.hidePushAlert = function() {
      $('#push_notification').fadeOut('slow', function() { $('#push_notification_text').html(''); });
    }
    
    this.switchActivity = function(activity) {  
      self.hidePushAlert();
      
      if (!activity || !Activity.options.currentActivity) {
        activity = $("#activity_type_filters li:eq(0) a");
      } else {        	
      	element = $(Activity.options.currentActivity);

      	element.removeClass("active");
      	element.parent("li").children("span").removeClass("loading");
    	}

    	$(activity).addClass("active");
    	$(activity).parent("li").children("span").addClass("loading");

      Activity.options.pushedTimestamps     = []
    	Activity.options.currentActivity      = $(activity);
    	Activity.options.activeActivityFilter = ($("#activity_type_filters").children('li').index($(activity).parent('li')));

    	Activity.options.buttonEnabled = true;
    	Activity.options.currentPage   = 1;
    	
        self.twitterHideShowFilter();      
    	self.loadActivity();
    }
    
    this.switchView = function(filter) {     
      if (!Activity.options.viewsEnabled) { return false; }
      
      self.hidePushAlert();      
       
      if (!filter || !Activity.options.currentActivity) {
        filter = $("#activity_filters li:eq(0) a");        
      } else {        	
      	$(Activity.options.currentView).removeClass("active");
    	}      
    	
      activeViewFilter = $("#activity_filters").children('li').index($("#activity_filters li a.active").parent("li"));
      _currentView = $("#activity_filters li:eq(" + activeViewFilter + ") a");
      
    	$(filter).addClass("active");    	
    	$("#activity_filters li.last").addClass("loading");

      Activity.options.pushedTimestamps = []
      Activity.options.viewsEnabled     = false
    	Activity.options.currentView      = $(filter);
    	Activity.options.activeViewFilter = ($("#activity_filters").children('li').index($(filter).parent('li')));

    	Activity.options.buttonEnabled = true;
    	Activity.options.currentPage   = 1;

        self.twitterHideShowFilter();
    	self.loadActivity();
    }
    
    /* NEXT RELEASE */
    this.twitterHideShowFilter = function() {
      currentOptions = Activity.options;
      if (currentOptions.arrActivityFilters[currentOptions.activeActivityFilter] == "twitter") {
        $("#activity_filters .filter").hide();        
        $("#twitter_only_filter").show();
      } else {
        $("#activity_filters .filter").show();
        $("#twitter_only_filter").hide();        
      }
    }
    
    // Give a time to the first call fill all activities
    Activity.options.buttonEnabled = true;         
    if (!self.isArtist()) {
      // Define current view
      Activity.options.activeViewFilter = $("#activity_filters").children('li').index($("#activity_filters li a.active").parent("li"));
      Activity.options.currentView      = $("#activity_filters li:eq(" + Activity.options.activeViewFilter + ") a"); 
      
      // Load activity first time
      self.switchActivity();
            
      $(self).oneTime("15s", function() {
        $(self).everyTime("15s", function() {
          self.check();
        });
      });      
    } else {
    	self.loadActivity();      
    }
  };
  
	$.fn.activityFeed = function() {
		return this.each(function() {
			var element = $(this);
			var activityFeed = new Activity.Feed();
			element.data('activityFeed', activityFeed);
		});
	};
})(jQuery);

jQuery(document).ready(function($){
  $('#activity').activityFeed();
});
