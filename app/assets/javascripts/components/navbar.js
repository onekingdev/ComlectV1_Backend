var bs_collapse = false;

$('.notifications-dropdown').parent().on('shown.bs.dropdown', function(e) {
  var th;
  th = 0;
  $('.notifications-dropdown > li').slice(0, 6).each(function() {
    th += $(this).height() + 1;
  });
  if (window.innerWidth < 1050) {
    $(".nav > li").not(".open").hide();
    th = window.innerHeight - 112;
  }
  $('.notifications-dropdown').css({
    'max-height': th + "px"
  });
});

$(".notifications-dropdown").parent().on('hidden.bs.dropdown', function(e) {
  return $(".nav > li").show();
});

var left_navbar_fit = function() {
  var tgt_scale = (window.innerHeight-100)/900.0;
  if (tgt_scale > 1.0) { tgt_scale = 1.0; }
  if (window.innerHeight < 600) {
    tgt_scale = 0.555;
    $("#left_navbar").css({position: "absolute"});
  } else {
    $("#left_navbar").css({position: "fixed"});
  }
  $("#left_navbar").css({"transform": "scale("+tgt_scale+")"});
  var tgt_padding = (window.innerHeight-100)/8;
  if (tgt_padding > 107) { tgt_padding = 107; }
  if ($(".panel-settings-body").length == 0) {
    $(".app_container").css({"padding-left": tgt_padding+"px"});
  }
  //$(".panel-default.settings").css({"margin-left": "-"+(tgt_padding)+"px"});
}

left_navbar_fit();
$(window).on("resize", function() { this.left_navbar_fit() });