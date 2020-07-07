var fullheight_all = function() {
  $(".fullheight").each(function() {
    var panel_heading = $(this).parent().parent().find(".panel-heading").outerHeight();
    var new_height = window.innerHeight-$(".fixedheight").outerHeight()-$("#header").outerHeight()-panel_heading;
    $(this).height(new_height-65);
  });

  $(".fixedheight_receiver").each(function() {
    var delta = $(this).parent().outerHeight()-$(this).outerHeight();
    var new_height = $(this).parent().innerHeight()+($(".fixedheight").innerHeight()-$(this).parent().innerHeight())-delta-(parseInt($(this).css("padding-top"))*2);
    $(this).height(new_height);
  });
}

fullheight_all();

$(document).ready(function() { fullheight_all(); });
$(window).on("resize", function() { this.fullheight_all(); });