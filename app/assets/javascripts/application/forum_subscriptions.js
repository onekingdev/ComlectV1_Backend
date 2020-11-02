var render_forum_sub_basic = function() {
  $("#subscription_modal *").show();
  $('#subscription_lvl_1').trigger('click');
  $('#subscription_lvl_0').hide();
  $('#subscription_lvl_0').next().hide();
  $('#subscription_lvl_0').next().next().hide();
  $('#subscription_lvl_2').hide();
  $('#subscription_lvl_2').next().hide();
  $('#subscription_lvl_2').next().next().hide();
  $(".pro_switch").hide();
  $('#subscription_modal .right-labels').css({'padding-top': '0px'});
}

var render_forum_sub_pro = function() {
  $("#subscription_modal *").show();
  $('#subscription_lvl_2').trigger('click');
  $('#subscription_lvl_0').hide();
  $('#subscription_lvl_0').next().hide();
  $('#subscription_lvl_0').next().next().hide();
  $('#subscription_lvl_1').hide();
  $('#subscription_lvl_1').next().hide();
  $('#subscription_lvl_1').next().next().hide();
  $(".basic_switch").hide();
  $('#subscription_modal .right-labels').css({'padding-top': '0px'});
}