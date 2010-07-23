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

  jQuery('#campaign_header_hexcolor').ColorPicker({
  	onSubmit: function(hsb, hex, rgb, el) {
  	  jQuery('#campaign_header_hexcolor').val(hex);
  	  $('#empty_header_hexcolor').css('backgroundColor', '#' + hex);
  	  jQuery('.colorpicker').hide();
  	},
  	onBeforeShow: function () {
  		jQuery(this).ColorPickerSetColor(this.value);
  	}
  })
  .bind('keyup', function(){
  	jQuery(this).ColorPickerSetColor(this.value);
  });  

  jQuery('#campaign_artistinfo_name_hexcolor').ColorPicker({
  	onSubmit: function(hsb, hex, rgb, el) {
  	  jQuery('#campaign_artistinfo_name_hexcolor').val(hex);
  	  $('#empty_artistinfo_name_hexcolor').css('backgroundColor', '#' + hex);
  	  jQuery('.colorpicker').hide();
  	},
  	onBeforeShow: function () {
  		jQuery(this).ColorPickerSetColor(this.value);
  	}
  })
  .bind('keyup', function(){
  	jQuery(this).ColorPickerSetColor(this.value);
  });  

  jQuery('#campaign_artistinfo_meta_hexcolor').ColorPicker({
  	onSubmit: function(hsb, hex, rgb, el) {
  	  jQuery('#campaign_artistinfo_meta_hexcolor').val(hex);
  	  $('#empty_artistinfo_meta_hexcolor').css('backgroundColor', '#' + hex);
  	  jQuery('.colorpicker').hide();
  	},
  	onBeforeShow: function () {
  		jQuery(this).ColorPickerSetColor(this.value);
  	}
  })
  .bind('keyup', function(){
  	jQuery(this).ColorPickerSetColor(this.value);
  });
  
  jQuery('#campaign_progressbar_hexcolor').ColorPicker({
  	onSubmit: function(hsb, hex, rgb, el) {
  	  jQuery('#campaign_progressbar_hexcolor').val(hex);
  	  $('#empty_progressbar_hexcolor').css('backgroundColor', '#' + hex);
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
  var headerhex = jQuery('#campaign_header_hexcolor').val();
  var artistinfoNameHex = jQuery('#campaign_artistinfo_name_hexcolor').val();
  var artistinfoMetaHex = jQuery('#campaign_artistinfo_meta_hexcolor').val();
  var progressBarHex = jQuery('#campaign_progressbar_hexcolor').val();
  $('#empty_hexcolor').css('backgroundColor', '#' + hex);
  $('#empty_header_hexcolor').css('backgroundColor', '#' + headerhex);
  $('#empty_artistinfo_name_hexcolor').css('backgroundColor', '#' + artistinfoNameHex);
  $('#empty_progressbar_hexcolor').css('backgroundColor', '#' + progressBarHex);
}

jQuery(document).ready(
  function() {
    colorize_box();
    attach_events_to_textfield();
  }
);
