function attach_events_to_textfield() {
  jQuery('#campaign_hexcolor').ColorPicker({
  	onSubmit: function(hsb, hex, rgb, el) {
  	  jQuery('#campaign_hexcolor').val(hex);
  	  $('#empty_hexcolor').css('backgroundColor', '#' + hex);
  	  jQuery('.colorpicker').hide();
  	},
  	onBeforeShow: function () {
  		jQuery(this).ColorPickerSetColor(this.value);
  	}
  })
  .bind('keyup', function(){
  	jQuery(this).ColorPickerSetColor(this.value);
  });  
}

function colorize_box() {
  var hex = jQuery('#campaign_hexcolor').val();
  $('#empty_hexcolor').css('backgroundColor', '#' + hex);
}

jQuery(document).ready(
  function() {
    colorize_box();
    attach_events_to_textfield();
  }
);
