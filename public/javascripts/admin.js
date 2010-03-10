$.facebox.settings.opacity = 0.5;
$("a.facebox").livequery(function() {
  $(this).click(function() {
    return false;
  }).facebox();
});