$(document).ready(function() {
    //Updates station name
/*    $("h4 span").editable(function(value, settings) {
      $.ajax({
              type: "PUT",
              url: "/my/stations/" + this.id,
              data: "id=" + this.id + "&user_station[name]=" + value
      });  
      return value;
    }, {
      type : 'text',
      submit : 'Save'
    });
*/
    $("ul li div.tools span").click(function () {
      $(this).parent().parent().parent().find("h4 span").click();
      return false;
    });

});
