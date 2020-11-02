$(".notification_destroyer").on("click", function(e) {
  e.preventDefault();
  $.get($(this).attr("href"));
  $(this).parent().parent().remove();
  return false;
})