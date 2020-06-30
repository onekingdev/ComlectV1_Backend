$(document).ready(function() {
  var coolnotify_div = $("<div id='coolnotify'></div>");
  $("body").append(coolnotify_div);
});

var coolnotify = function(msg, btnClass) {
  $("#coolnotify").html("<div class='btn-"+btnClass+" btn'>"+msg+"</div>");
  $("#coolnotify").fadeIn(500, function() {
    setTimeout(function() {
      $("#coolnotify").fadeOut(500);
    }, 1000);
  });
}