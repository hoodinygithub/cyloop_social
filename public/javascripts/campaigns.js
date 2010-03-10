jQuery(document).ready(
  function() {
    jQuery('#campaign_hexcolor').ColorPicker({
    	onSubmit: function(hsb, hex, rgb, el) {
    	  jQuery('#campaign_hexcolor').val(hex);
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
);