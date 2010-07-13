$(document).ready(function() {
  function startPositionSaving() {
    $('#playlist_item_list').sortable('disable');
  }

  function endPositionSaving() {
    $('#playlist_item_list').sortable('enable');    
  }

  $('#playlist_item_list').sortable({
    update: function(ev, ui) {
			_pv.reorder_items();
/*      var to_index = $(this).children('li').index(ui.item) + 1;
      var playlist_id = $('#playlist_item_list').attr('playlist_id');
      var item_id = $(ui.item).attr('item_id');
      $.ajax({
        type: "POST",
        url: '/my/mixes/' + playlist_id + '/items/' + item_id,
        data: {_method: 'put', position: to_index, playlist_id: playlist_id},
				success: function() {
					_pv.reorder_items();
				},
        error: function() {
          alert("The song order could not be changed. Please try again later.");
          window.location.reload(true);
        }
      })
*/    }
  })
});
