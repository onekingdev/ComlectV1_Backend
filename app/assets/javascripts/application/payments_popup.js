var patch_payments_popup = function() {
  $("#add_payment_debit_credit").on("click", function() {
    $(".payment_bank_account_form").hide();
    $(".payment_debit_credit_form").show();
    $("#add_payment_debit_credit").addClass("active");
    $("#add_payment_bank_account").removeClass("active");
  });

  $("#add_payment_bank_account").on("click", function() {
    $(".payment_debit_credit_form").hide();
    $(".payment_bank_account_form").show();
    $("#add_payment_debit_credit").removeClass("active");
    $("#add_payment_bank_account").addClass("active");
  });

  $(".payment_bank_account_form").hide();
}

$(document).ready(function() {
  if (typeof(enable_patch_payments_popup) != "undefined") {
    patch_payments_popup();
    patch_payment_form();
  }
})
