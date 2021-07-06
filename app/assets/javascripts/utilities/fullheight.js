var fullheight_all = function() {
  $(".fullheight").each(function() {
    var panel_heading = $(this).parent().parent().find(".panel-heading").outerHeight();
    var new_height = window.innerHeight-$($(".fixedheight")[0]).outerHeight()-$("#header").outerHeight()-panel_heading;
    $(this).height(new_height-65);
  });

  $(".fixedheight_receiver").each(function() {
    var delta = $(this).parent().outerHeight()-$(this).outerHeight();
    var new_height = 0;
    if ($(".fixedheight").length > 0) {
      new_height = $(this).parent().innerHeight()+($(".fixedheight").innerHeight()-$(this).parent().innerHeight())-delta-(parseInt($(this).css("padding-top"))*2);
    } else {
      new_height = $(this).parent().innerHeight()-$(this).parent().parent().find(".panel-heading").outerHeight()-40;
    }
    $(this).height(new_height);
  });

  if (($(".fullheight").length > 0) && ($(".pdf_preview_fullheight").length > 0)) {
    $(".pdf_preview_fullheight, .pdf_preview_area").height($($(".fullheight")[0]).height());
  }
}

fullheight_all();

$(document).ready(function() { fullheight_all(); });
$(window).on("resize", function() { this.fullheight_all(); });