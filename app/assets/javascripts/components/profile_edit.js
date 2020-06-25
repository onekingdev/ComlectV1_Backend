if (typeof(business_profile_edit_page) != "undefined") {
  $("#business_logo[type=file]").on("change", function() {
    $(".simple_form.edit_business").submit();
  });
  var filter_edit_industries = function() {
    var industry_ids = [];
    for (var inp of $(".simple_form.edit_business").serializeArray()) {
      if (inp.name == "business[industry_ids][]") {
        if (parseInt(inp.value) > 0) {
          industry_ids.push(parseInt(inp.value));
        }
      }
    }
    $(".business_sub_industries .col-sm-12").hide();
    $(".business_sub_industries input").each(function() {
      if (industry_ids.indexOf(parseInt(($(this).val().split("_")[0]))) > -1) {
        $(this).parent().show();
      } else {
        $(this).attr("checked", false);
        $(this).parent().hide();
      }
    });
  }
  $("#business_industry_ids").on("change", function() {
    filter_edit_industries();
  });
  filter_edit_industries();
}