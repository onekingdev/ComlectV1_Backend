var patch_profile_edit = function(logo_input, target_form, user_type, ) {
  logo_input.on("change", function() {
    target_form.submit();
  });
  var filter_edit_industries = function() {
    var industry_ids = [];
    for (var inp of target_form.serializeArray()) {
      if (inp.name == user_type+"[industry_ids][]") {
        if (parseInt(inp.value) > 0) {
          industry_ids.push(parseInt(inp.value));
        }
      }
    }
    $("."+user_type+"_sub_industries .col-sm-12").hide();
    $("."+user_type+"_sub_industries input").each(function() {
      if (industry_ids.indexOf(parseInt(($(this).val().split("_")[0]))) > -1) {
        $(this).parent().show();
      } else {
        $(this).attr("checked", false);
        $(this).parent().hide();
      }
    });
  }
  $("#"+user_type+"_industry_ids").on("change", function() {
    filter_edit_industries();
  });
  filter_edit_industries();
  if (user_type == "specialist") {
    if (typeof(confirmed_skills) != "undefined") {
      TagCloud("#skills_tagcloud", confirmed_skills, { keep: false, initSpeed: 'slow' });
    }
    $("#no_sub_jurs").on("change", function() {
      if ($(this).prop("checked")) {
        $(".specialist_sub_jurisdictions input[type=checkbox]").prop("checked", false);
        $(this).prop("checked", true);
      }
    })
    var filter_edit_jurisdictions = function() {
      var jurisdiction_ids = [];
      for (var inp of target_form.serializeArray()) {
        if (inp.name == user_type+"[jurisdiction_ids][]") {
          if (parseInt(inp.value) > 0) {
            jurisdiction_ids.push(parseInt(inp.value));
          }
        }
      }
      $(".specialist_jurisdiction_states_usa").parent().hide();
      $(".specialist_jurisdiction_states_canada").parent().hide();
      $("."+user_type+"_sub_jurisdictions .col-sm-12").hide();
      $("."+user_type+"_sub_jurisdictions input").each(function() {
        if (jurisdiction_ids.indexOf(parseInt(($(this).val().split("_")[0]))) > -1) {
          $(this).parent().show();
        } else {
          $(this).attr("checked", false);
          $(this).parent().hide();
        }
      });
      $(".specialist_jurisdictions option:selected").each(function() {
        if ($(this).text().indexOf("USA") > -1) {
          $(".specialist_jurisdiction_states_usa").parent().show();
          $(".specialist_jurisdiction_states_usa").show();
          $(".specialist_jurisdiction_states_usa label.checkbox").show();          
        }
        if ($(this).text().indexOf("Canada") > -1) {
          $(".specialist_jurisdiction_states_canada").parent().show();
          $(".specialist_jurisdiction_states_canada").show();
          $(".specialist_jurisdiction_states_canada label.checkbox").show();
        }
      });
      $("#no_sub_jurs").parent().show();
    }
    $("#"+user_type+"_jurisdiction_ids").on("change", function() {
      filter_edit_jurisdictions();
    });
    filter_edit_jurisdictions();
    if (typeof(no_sub_jurs_force) != "undefined") {
      $("#no_sub_jurs").prop("checked", true);
    }
    $(".specialist_sub_jurisdictions input[type=checkbox]").on("change", function() {
      if ($(this).attr("id") != "no_sub_jurs") {
        if ($(this).prop("checked")) {
          $("#no_sub_jurs").prop("checked", false);
        }
      }
    })
  }
}

if (typeof(business_profile_edit_page) != "undefined") {
  patch_profile_edit($("#business_logo[type=file]"), $(".simple_form.edit_business"), "business");
}

if (typeof(specialist_profile_edit_page) != "undefined") {
  patch_profile_edit($("#specialist_photo[type=file]"), $(".simple_form.form-specialist"), "specialist");
}