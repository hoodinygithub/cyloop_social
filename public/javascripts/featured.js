var ids       = new Array();
var titles    = new Array(); 
var subtitles = new Array(); 
var images    = new Array();
var thumbs    = new Array(); 
var links     = new Array(); 
var alts      = new Array();

var featuredInterval;

function setFeaturedArtist(index, id) {
   // link
   $('#featured_large_image a').attr("title", titles[index]);
   $('#featured_large_image a').attr("href", links[index]);
   // image
   $('#featured_large_image img').attr("src", images[index]);
   $('#featured_large_image img').attr("id", id);
   $('#featured_large_image img').attr("alt", alts[index]);
   // div.meta
   $('#featured_large_image .meta a').attr("href", links[index]);
   $('#featured_large_image .meta a').text(titles[index]);
   $('#featured_large_image .meta span').text(subtitles[index]);
}

function swapManual(index, id) {
	clearInterval(featuredInterval);		
	var $active = $('#featured_list LI.active');
	if ($active) $active.removeClass('active');
	$("#t"+index).addClass("active");		
	setFeaturedArtist(index, id);
}

function swapOut() {	
	featuredInterval = setTimeout("swapAuto();", 5000);
}

function swapAuto() {
	var $active = $('#featured_list LI.active');

	if ( $active.length == 0 )
		$active = $('#featured_list LI:last');

	// use this to pull the divs in the order they appear in the markup
	var $next = $active.next();
	if (!$next.length) 
		$next = $('#featured_list LI:first');

	$active.removeClass('active');
	$next.addClass('active');
	
	var index = parseInt($next.attr("id").replace("t",""));
	var id = ids[index];
	setFeaturedArtist(index, id);
	

	featuredInterval = setTimeout("swapAuto();", 5000);
}

