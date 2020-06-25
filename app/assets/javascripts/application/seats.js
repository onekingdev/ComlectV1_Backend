var patch_seats = function() {
  var calculate_price = function() {
    var d = $(".seats_purchase_form").serializeArray();
    if (d[0].value == "monthly") {
      $(".plan_charge_single_seat").html("12/mo");
      $(".plan_charge_total").html((12*parseInt(d[1].value))+"/mo");
    }
    if (d[0].value == "annual") {
      $(".plan_charge_single_seat").html("120/yr");
      $(".plan_charge_total").html((120*parseInt(d[1].value))+"/yr");
    }
  }
  $(".seats_purchase_form input").on('keyup', calculate_price);
  $(".seats_purchase_form input").on('change', calculate_price);
}

$(document).ready(function() {
  if (typeof(patch_seats_enable) != "undefined") {
    patch_seats();
  }
})
