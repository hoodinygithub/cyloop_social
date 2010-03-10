$(document).ready(function() {

	var template_html = "" + 
	"<li class=\"listen activity clearfix\" artist_id=\"${artist_id}\" song_id=\"${song_id}\" " + 
	 "song_file=\"${song_file_name}\" label=\"${artist_label_name}\" genre=\"${song_genre_name}\">" +
	"<div class='avatar'>" + 
		"<a href='/${artist_slug}'><img src='${avatar_file_name}' class='avatar small' alt='${artist_name}'></a>" + 
	"</div>" +
	"<div class='item'>" +
	"<h4>${song_title}</h4>" + 
	"</div>" +
	"</li>";
	var template = $.template(template_html.replace("\n", ' '));
	$.getJSON('/my/dashboard.json', function(data) {
		$.each(data, function(i, item) {
			var activity = eval('(' + item['activity'] + ')');
			$("ul.activities").append(template, {
				user_id: activity.user.id,
				user_name: activity.user.name,
				timestamp: $.timeago(new Date(activity.timestamp)),
				song_id: activity.item.id,
				song_file_name: activity.item.file_name,
				song_genre_name: activity.item.genre_name,
				song_title: activity.item.title,
				avatar_file_name: avatar_for_activity(activity.album.avatar_file_name, activity.user.id, 'M', {}, 'small'),
				artist_id: activity.artist.id,
				artist_name: activity.artist.name,
				artist_slug: activity.artist.slug
			});
		});
	});
});


function avatar_for_activity(path, user_id, gender, options, size) {
	if (typeof(path) != 'undefined') {
		if (path.indexOf('/.elhood.com') != -1) {
			if (size == 'medium') {
				path = path.replace('hires', 'hi-thumbnail');
			}
			if (size == 'album') {
				path = path.replace('hires', 'thumbnail');
			}
		} else {
			
		}
		
		if (path =='/avatars/missing/missing.png') {
			path = '/avatars/missing/artist.gif';
		}
		
		
	}
	
	return path;
}