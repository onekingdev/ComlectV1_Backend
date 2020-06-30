var patch_ported = function() {
  var calculate_price = function() {
    console.log(d);
    var d = $(".turnkey_purchase_form").serializeArray();
    if (d[0].value == "monthly") {
      $(".plan_charge_single_turnkey").html("30/mo");
      $(".plan_charge_total").html("30/mo");
    }
    if (d[0].value == "annual") {
      $(".plan_charge_single_turnkey").html("300/yr");
      $(".plan_charge_total").html("300/yr");
    }
  }
  $(".turnkey_purchase_form input").on('change', calculate_price);
}

$(document).ready(function() {
  if (typeof(patch_ported_enable) != "undefined") {
    patch_ported();
  }
});
