(function($) {
	var ActivityFeedSwitcher = function() {
		var filters = new Array('all', 'playlist', 'station', 'status', 'twitter');
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
if(!String.trim){
  String.prototype.trim = function () {
    return this.replace(/^\s*/, "").replace(/\s*$/, "");
  }  
}

(function($) {
  Activity = {
    options: {
      arrActivityFilters: ['all', 'playlist', 'station', 'status', 'twitter'],
      activeActivityFilter: 0,
      arrViewFilters: ['all', 'me', 'following'],
      activeViewFilter: 0,
      buttonEnabled: false,
      currentActivity: null,    
      currentView: null,
      currentPage: 1,
      limit: 15,
      viewsEnabled: true,
      pushTimer: true, 
      pushInterval: 15000, 
      itemsToPush: 0, 
      format: "js",
      justUpdateQty: false,
      pushedTimestamps: [],
      skipAutoLoad: false,
      skipFilterConfig: false
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
      data.limit  = options.limit || currentOptions.limit;
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
        $("#activity_filters .last").addClass("loading");
        if (currentOptions.buttonEnabled)
    	    $('#activity_more').html(Base.layout.spanned_spin_image());
      } else {
        $("#activity_filters .last").removeClass("loading");
        if (currentOptions.buttonEnabled) {
        	var more_text = "<span><span>"+Base.locale.t("actions.show_more")+"</span></span>";
    	    $('#activity_more').html(more_text);        	
        }
      }
    }
    
    this.enableMore = function(){
    	Activity.options.buttonEnabled = true;
    	var more_text = "<span><span>"+Base.locale.t("actions.show_more")+"</span></span>";
    	$('#activity_more').text(more_text);
      $('.more_button').show();
    }

    this.disableMore = function(){
    	Activity.options.buttonEnabled = true;
    	var no_more_text = "<span><span>"+Base.locale.t("activity.no_more_activity")+"</span></span>";
    	$('#activity_more').text(no_more_text);
      $('.more_button').hide();
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
    }
    
    this.page = function() {
      // if (self.isArtist())
      //   return Activity.options.currentPage;
      // else
        return 1;
    }
    
    this.moreButtonVisibility = function() {
			al = $('.activities').children().length
			if( al == 0 || al % Activity.options.limit )
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
          // if (self.isArtist()) {
          //   self.appendResponse(response);
          //   Activity.options.currentPage++;
          //   self.moreButtonVisibility();
          // } else {
            if (Activity.options.firstLoad && response.trim() == "") {
              $("#user_has_no_activity").show();
            } else {
              $("#user_has_no_activity").hide();              
            }
            lastTimestamp = self.getTimestamp("last");
            if ( timestamp == lastTimestamp && Activity.options.pushedTimestamps.indexOf(lastTimestamp) < 0 ) {
              Activity.options.pushedTimestamps.push(lastTimestamp);
              self.appendResponse(response);
            } else {
              console.log('Item already pushed: ' + timestamp );
            }
            self.moreButtonVisibility();
          // }
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
    	
      // self.twitterHideShowFilter();      
    	self.loadActivity();
    }
    
    this.switchView = function(filter) {     
      if (!Activity.options.viewsEnabled) { return false; }
      
      self.hidePushAlert();      
       
      if (!filter || !Activity.options.currentActivity) {
        filter = $("#activity_filters a:eq(0)");
      } else {        	
      	$(Activity.options.currentView).removeClass("active");
    	}      
    	
      activeViewFilter = $("#activity_filters").children('a').index($("#activity_filters .active"));
      _currentView = $("#activity_filters a:eq(" + activeViewFilter + ")");
      
    	$(filter).addClass("active");    	
    	$("#activity_filters .last").addClass("loading");

      Activity.options.pushedTimestamps = []
      Activity.options.viewsEnabled     = false
    	Activity.options.currentView      = $(filter);
    	Activity.options.activeViewFilter = ($("#activity_filters").children('a').index($(filter)));
    	Activity.options.buttonEnabled = true;
    	Activity.options.currentPage   = 1;

      // self.twitterHideShowFilter();
    	self.loadActivity();
    }
    
    /* NEXT RELEASE */
    // this.twitterHideShowFilter = function() {
    //   currentOptions = Activity.options;
    //   if (currentOptions.arrActivityFilters[currentOptions.activeActivityFilter] == "twitter") {
    //     $("#activity_filters .filter").hide();        
    //     $("#twitter_only_filter").show();
    //   } else {
    //     $("#activity_filters .filter").show();
    //     $("#twitter_only_filter").hide();        
    //   }
    // }
    
    Activity.options.buttonEnabled = true;         
    // if (!self.isArtist()) {
      if (!Activity.options.skipFilterConfig) {
        // Define current view
        Activity.options.activeViewFilter = $("#activity_filters").children('a').index($("#activity_filters a.active"));
        Activity.options.currentView      = $("#activity_filters a:eq(" + Activity.options.activeViewFilter + ")"); 
      }      
      // Load activity first time
      if ( !Activity.options.skipAutoLoad ) {
        self.switchActivity();
      } else {
        self.loading(false);
      }
           
      // Push only on user accounts and dashboard
      if(!self.isArtist()) {
        $(self).oneTime("15s", function() {
          $(self).everyTime("15s", function() {
            self.check();
          });
        }); 
      }
    // } else {
    //   if ( !Activity.options.skipAutoLoad )
    //    self.loadActivity();      
    // }
  };
  
	$.fn.activityFeed = function() {
		return this.each(function() {
			var element = $(this);
			var activityFeed = new Activity.Feed();
			element.data('activityFeed', activityFeed);
		});
	};
})(jQuery);