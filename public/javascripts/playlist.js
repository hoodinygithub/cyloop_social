$(document).ready(function() {
  function startPositionSaving() {
    $('.songs_private').sortable('disable');
  }

  function endPositionSaving() {
    $('.songs_private').sortable('enable');    
  }

  $('.songs_private').sortable({
    update: function(ev, ui) {
      var to_index = $(this).children('li').index(ui.item) + 1;
      var playlist_id = $('.songs_private').attr('playlist_id');
      var item_id = $(ui.item).attr('id');
      $.ajax({
        type: "POST",
        url: '/my/playlists/' + playlist_id + '/items/' + item_id,
        data: {_method: 'put', position: to_index, playlist_id: playlist_id},
        error: function() {
          alert("The playlist order could not be changed. Please try again later.");
          window.location.reload(true);
        }
      })
    }
  })
});
