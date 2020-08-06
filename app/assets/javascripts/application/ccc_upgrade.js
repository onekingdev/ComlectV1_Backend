var patch_ccc = function() {
  var calculate_price = function() {
    var d = $(".turnkey_purchase_form").serializeArray();
    if (d[0].value == "monthly") {
      $(".plan_charge_single_turnkey").html("50");
      $(".plan_charge_total_today").html("550");
      $(".plan_charge_total_recurring").html("50/mo");
    }
    if (d[0].value == "annual") {
      $(".plan_charge_single_turnkey").html("500");
      $(".plan_charge_total_today").html("1000");
      $(".plan_charge_total_recurring").html("500/yr");
    }
  }
  $(".turnkey_purchase_form input").on('change', calculate_price);
  $('.business-upgrade-ccc').on('ajax:success', function(e, data, status, xhr){
    console.log(data.message);
    window.location.href = '/business/settings/subscriptions';
  }).on('ajax:error',function(e, xhr, status, error){
    // show alert message
    console.log('error message');
    console.log(xhr.responseJSON.message);
  });
}

$(document).ready(function() {
  if (typeof(patch_ccc_enable) != "undefined") {
    patch_ccc();
  }
});
