(function($) {
  Chat = {
    interval: "5s",
    toggleStatus: true
  }

  Chat.MessageChecker = function() {
    var self = this;

    if ( stopAllJavascripts ) return false;

    this.enable = function() {
      Chat.toggleStatus = true;
      $("#toggleMessageChecker").removeClass("disabled").addClass("enabled");
      $("#toggleMessageChecker").find("span").html(toggle_on);
    }

    this.disable = function() {
      Chat.toggleStatus = false;
      $("#toggleMessageChecker").removeClass("enabled").addClass("disabled");
      $("#toggleMessageChecker").find("span").html(toggle_off);
    }

    this.toggle = function() {
      if (Chat.toggleStatus) {
        $("#toggleMessageChecker").data("messageChecker").disable();
      } else {
        $("#toggleMessageChecker").data("messageChecker").enable()
      }
    }
    $("#toggleMessageChecker").bind("click", this.toggle);
    $(window).bind("blur",  this.disable);
    $(window).bind("focus", this.enable);        

    this.check = function() {
      if ( stopAllJavascripts ) return false;      
      if ($("ul li:last").length) {
        last_message_id = $("ul li:last").attr("id").replace("message_", "");
      }else{
        last_message_id = 0
      }
      // Skip if disabled
      if (!Chat.toggleStatus) {
        get_moderator_n_messages(chat_id,last_message_id);
        return false;
      }
      $.getJSON("/admin/chats/"+chat_id+"/messages", {format: "json", message_id: last_message_id},
        function(json) {
          if (parseInt(json.length) > 0) {
            jQuery.each(json, function(index, message) {
              str='<li class=\'clearfix cover_art message\' id=\'message_'+message.id+'\'>';
              str=str+'<div class=\'info_chat\'><h4>'+message.name+' from '+message.location+'</h4><div class=\'meta_chat\'>';
              str=str+message.question+'</div><div class=\'tools_right\'>'
              str=str+'<a href=\"message\" class=\"approve\" id=\"btnapprove_'+message.id+'\" onclick=\"return false;\" ></a></div></div></li>'
              $("ul").append(str);
              $(".approve").click(function() {
                process_message(this.id);
              });
            });
          }
          $("#messages_number").html("0 More Questions");
        }
      );
    }

    // Start timers with small delay (5s until the first request)
    $(self).oneTime(Chat.interval, function() {
      $(self).everyTime(Chat.interval, function() {
        self.check();
      });
    });
  }

	$.fn.messageChecker = function() {
		return this.each(function() {
			var element = $(this);
			var messageChecker = new Chat.MessageChecker();
			element.data('messageChecker', messageChecker);
		});
	};
})(jQuery);


(function($) {
  MessageNumber = {
    interval: "5s"
  }

  MessageNumber.N_messageChecker = function() {
    var self = this;

    this.check = function() {
      if ( stopAllJavascripts ) return false;
      message_id = $(".back").attr("id").split("_")[1];
      adjust_interviewee_moremessages(chat_id,message_id)
    }

    // Start timers with small delay (5s until the first request)
    $(self).oneTime(Chat.interval, function() {
      $(self).everyTime(Chat.interval, function() {
        self.check();
      });
    });
  }

	$.fn.n_messageChecker = function() {
		return this.each(function() {
			var element = $(this);
			var n_messageChecker = new MessageNumber.N_messageChecker();
			element.data('n_messageChecker', n_messageChecker);
		});
	};
})(jQuery);


var stopAllJavascripts = false;
var btn_id;

$(document).ready(function(){
  $("#emergency_button").click(function() {
    if ( stopAllJavascripts ) {
      $("#emergency_button").text("turn off")
    } else {
      $("#emergency_button").text("turn on")      
    }
    stopAllJavascripts = !stopAllJavascripts;
    console.log("Status atual:" + stopAllJavascripts);
  });
  
  $(".approve, .unapprove").click(function() {
    process_message(this.id);
  });

  $(".back").click(function() {
    back_approved_message(this.id)
  });

  $(".next").click(function() {
    next_approved_message(this.id)
  });
});

function process_message(id)
{
  if (btn_id != id){
    if (id.split("_")[0] == 'btnapprove'){
      approve_message(id);
    }else{
      unappove_message(id);
    }
  }

}

function approve_message(id)
{
  var btn=id.split("_")[0];
  var idx=id.split("_")[1];

  $.getJSON("/admin/messages/"+idx+"/approve", {format: "json", message_id: idx},
    function(json) {
        jQuery.each(json, function(index, message) {
           if (message.status=='approved'){
             var li_idx=idx-1;
             $("#"+id).removeClass("approve");
             $("#"+id).addClass("unapprove");
             $("#"+id).attr("id",'btnunapprove_'+idx);
             $("#message_"+idx).addClass("clearfix approved");
           }
        });
    }
  );
  btn_id = id;
}

function unappove_message(id)
{
  var btn=id.split("_")[0];
  var idx=id.split("_")[1];

  $.getJSON("/admin/messages/"+idx+"/unapprove", {format: "json", message_id: idx},
    function(json) {
        jQuery.each(json, function(index, message) {
          if (message.status=='pending'){
            var li_idx=idx-1;
            $("#"+id).removeClass("unapprove");
            $("#"+id).addClass("approve");
            $("#"+id).attr("id",'btnapprove_'+idx);
            $("#message_"+idx).removeClass("approved");
          }
        });
    }
  );
  btn_id = id;
}

function next_approved_message(id)
{
  var chat_id=id.split("_")[0];
  var message_id=id.split("_")[1];
  
  if ($(".disabled").length > 0) return false;
  
  $(".next").text("...");

  $.getJSON("/admin/messages/"+message_id+"/next", {format: "json", message_id: message_id, chat_id: chat_id},
    function(json) {
      if (json==null) {return false;}
      jQuery.each(json, function(index, message) {
        location_text = message.name+" from "+message.location;
        if (message.pre_submitted) { location_text += " <em class='pre_submitted'>(pre-submitted)</em>" }        
        $(".location").html(location_text);
        $(".question").html(message.question);
        $(".back").attr("id",chat_id+'_'+message.id);
        $(".next").attr("id",chat_id+'_'+message.id);
        $(".next").text("NEXT").removeClass("disabled");        
        $(".no_message").html('');
        adjust_interviewee_moremessages(chat_id,message.id)
      });
    }
  );
}

function back_approved_message(id)
{
  var chat_id=id.split("_")[0];
  var message_id=id.split("_")[1];

  $.getJSON("/admin/messages/"+message_id+"/back", {format: "json", message_id: message_id, chat_id: chat_id},
    function(json) {
      if (json==null) {return false;}
      jQuery.each(json, function(index, message) {
         location_text = message.name+" from "+message.location;
         if (message.pre_submitted) { location_text += " <em class='pre_submitted'>(pre-submitted)</em>" }
         $(".location").html(location_text);
         $(".question").html(message.question);
         $(".back").attr("id",chat_id+'_'+message.id);
         $(".next").attr("id",chat_id+'_'+message.id);
         adjust_interviewee_moremessages(chat_id, message.id);
      });
    }
  );
}

function get_moderator_n_messages(chat_id,message_id)
{
  if ( stopAllJavascripts ) return false;
  $.getJSON("/admin/messages/"+message_id+"/more", {format: "json", message_id: message_id, chat_id: chat_id},
    function(json) {
      $("#messages_number").html(json+" More Questions ");
    }
  );
}

function adjust_interviewee_moremessages(chat_id,message_id)
{
  if ( stopAllJavascripts ) return false;  
  $.getJSON("/admin/messages/"+message_id+"/more_interviewee", {format: "json", message_id: message_id, chat_id: chat_id},
    function(count) {
      if (parseInt(count) == 0) { $(".next").hide(); }
      else { $(".next").show(); }
      $("#messages_number").html(count+" More Questions ");
      return count;
    }
  );
}

