if ((window.location.pathname == "/businesses/new") || ($("body").hasClass("businesses") && $("body").hasClass("create"))) {
  var no_pwd_focus = false;
  var pwd_focused = false;
  var step_names = ['step0', 'step1', 'step2', 'step21', 'step3', 'step4', 'step41', 'step42', 'step5'];
  var step_cookies = {};
  var required_fields_step0 = ["#business_contact_first_name", "#business_contact_last_name", "#business_business_name", "#business_address_1", "#business_city", "#business_state", "#business_country", "#business_time_zone", "#business_employees", "#business_client_account_cnt", "#business_total_assets", "#business_user_attributes_password_confirmation"];
  var cookie_form_attrs = ["#business_contact_first_name", "#business_contact_last_name", "#business_user_attributes_email", "#business_business_name", "#business_contact_job_title", "#business_contact_phone", "#business_address_1", "#business_address_2", "#business_city", "#business_state", "#business_zipcode", "#business_client_account_cnt", "#business_total_assets"];

  var step_signup_continue = function() {
    for (var name of step_names) {
      if (name == "step0") {
        $(".business_step0 .continue").prop("disabled", true);
        if (validateEmail($("#business_user_attributes_email").val())) {
          if ($("#business_user_attributes_password").val().length > 5) {
            $("#business_user_attributes_password").removeClass("form_error");
            var prop_disabled = false;
            if ($("#business_user_attributes_password").val() != $("#business_user_attributes_password_confirmation").val()) {
              $("#business_user_attributes_password_confirmation").addClass("form_error");
              prop_disabled = true;
            } else {
              $("#business_user_attributes_password_confirmation").removeClass("form_error");
            }
            for (field of required_fields_step0) {
              if (!($(field).val().length > 0)) {
                prop_disabled = true;
              }
            }
            $(".business_step0 .continue").prop("disabled", prop_disabled);
          } else {
            $("#business_user_attributes_password").addClass("form_error");
            if ((pwd_focused == false) && (no_pwd_focus == false)) {
              pwd_focused = true;
              $("#business_user_attributes_password").focus();
            }
          }
        }
      } else {
        if ((name != "step3") && (name != "step5")) {
          $(".business_"+name).find(".continue").prop("disabled", !($(".business_"+name+" .choices .active").length > 0));
        }
      }
    }
  }

  var validateEmail = function(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  $(document).ready(function() {
    var num_to_opinion = function(n) {
      return ["strongly<br>disagree", "somewhat disagree", "I don't know", "somewhat agree", "strongly<br>agree"][n-1];
    }

    if (typeof(Cookies.get("complect_step4")) != "undefined") {
      $(".signup_products .product[data-product="+Cookies.get("complect_step4")+"]").addClass("active");
      $(".btn_step6").prop("disabled", false);
    }

    $("#specify_other").hide();
    for (var name of step_names) {
      step_cookies[name] = Cookies.get('complect_'+name);
    }

    if (typeof(step_cookies["step3"]) == "undefined") {
      step_cookies["step3"] = "3-3-3";
      Cookies.set("complect_step3", "3-3-3");
    }

    var set_risks_cookie = function() {
      Cookies.set("complect_step3", $("#business_risks_1").val()+"-"+$("#business_risks_2").val()+"-"+$("#business_risks_3").val());
    }

    $("#business_risks_1").ionRangeSlider({
      grid: false,
      from: step_cookies["step3"].split("-")[0],
      min: 1,
      max: 5,
      prettify: num_to_opinion,
      onChange: function(data) {
        set_risks_cookie();
      }
    });

    $("#business_risks_2").ionRangeSlider({
      grid: false,
      from: step_cookies["step3"].split("-")[1],
      min: 1,
      max: 5,
      prettify: num_to_opinion,
      onChange: function(data) {
        set_risks_cookie();
      }
    });

    $("#business_risks_3").ionRangeSlider({
      grid: false,
      from: step_cookies["step3"].split("-")[2],
      min: 1,
      max: 5,
      prettify: num_to_opinion,
      onChange: function(data) {
        set_risks_cookie();
      }
    });

    $("#specify_other").on("keyup", function() {
      $(this).parent().find("span").html("Other ("+$(this).val()+")");
    });

    if (typeof(Cookies.get("complect_step5")) != "undefined") {
      $(".signup_products[data-product="+Cookies.get("complect_step5")+"]").addClass("active");
    }

    for (cookie_attr of cookie_form_attrs) {
      $(cookie_attr).val(Cookies.get(cookie_attr.replace("#business_", "complect_")));
    }

    $(".business_step0").show();
    var other = Cookies.get("complect_other");
    if (other != undefined) {
      for (var choice of $(".business_step2 .btn-block")) {
        if ($(choice).text().indexOf("Other") > -1) {
          if (other.length > 0) {
            $(choice).find("span").html("Other ("+other+")");
            $("#specify_other").val(other);
          } else {
            $(choice).find("span").html("Other");
          }
        }
      }
    }

    for (var name of step_names) {
      if ((step_cookies[name] != undefined) && (name != "step1") && (name != "step2") && (name != "step21")) {
        for (var num of step_cookies[name].split("-")) {
          var choice = $($(".business_"+name+" .btn-block")[parseInt(num)]);
          choice.addClass("active");
          choice.find("input[type=checkbox]").prop("checked", true);
        }
      }
    }

    if ((step_cookies["step2"] != undefined) && (step_cookies["step2"].length > 0)) {
      for (var num of step_cookies["step2"].split("-")) {
        var choice = $(".business_step2 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
      render_step21();
    }

    if ((step_cookies["step1"] != undefined) && (step_cookies["step1"].length > 0)) {
      for (var num of step_cookies["step1"].split("-")) {
        var choice = $(".business_step1 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_signup_continue();
  });

  var render_step21 = function() {
    var nums = [];
    var cookies_step2 = Cookies.get('complect_step2');
    if ((cookies_step2 != undefined) && (cookies_step2.length > 0)) {
      for (var num of cookies_step2.split("-")) {
        nums.push(parseInt(num));
      }
    }

    $(".business_step21 .choices .col-sm-12").hide();
    for (var num of nums) {
      var cb = $(".business_step2 .choices input[value="+num+"]");
      var cb_txt = cb.parent().text();
      $(".business_step21 .choices .col-sm-12").each(function() {
        if (parseInt($(this).find("input[type=checkbox]").val().split("_")[0]) == num) {
          $(this).show();
        }
      });
    }
    nums = Cookies.get("complect_step21");
    if ((nums != undefined) && (nums.length > 0)) {
      for (var num of nums.split("-")) {
        var active_btn = $(".business_step21 .choices input[value="+num+"]").parent();
        active_btn.addClass("active");
        active_btn.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_signup_continue();
  }

  $("#business_user_attributes_email").on('keyup', function(e) {
    if (validateEmail($(this).val())) {
      $(this).removeClass("form_error");
    } else {
      $(this).addClass("form_error");
    }
    Cookies.set("complect_email", $(this).val(), { expires: 7 });
    no_pwd_focus = true;
    step_signup_continue();
  });

  $(cookie_form_attrs.join(", ")).on('keyup', function(e) {
    Cookies.set($(this).attr('id').replace("business_", "complect_"), $(this).val(), { expires: 7 });
    step_signup_continue();
  });

  $("#business_user_attributes_password, "+required_fields_step0.join(", ")).on('keyup', function() {
    step_signup_continue();
  });

  $("#business_user_attributes_password, "+required_fields_step0.join(", ")).on('change', function() {
    step_signup_continue();
  });

  $(".btn_step_jump").on('click', function() {
    $(".business_step").hide();
    var shown = false;
    for (var i = 1; i < 4; i++) {
      var name = step_names[i];
      if (step_cookies[name] == undefined) {
        if (step_names[i] == "step21") {
          var step2_cc = Cookies.get("complect_step2");
          var skip = true;
          if (step2_cc != undefined) {
            var step2_c = step2_cc.split("-");
            for (kookie of step2_c) {
              if (sub_inds.indexOf(parseInt(kookie)) > -1) {
                skip = false;
              }
            }
          }
          if (skip == true) {
            $(".business_step3").show();
          } else {
            $(".business_step21").show();
          }
        } else {
          $(".business_"+step_names[i]).show();
        }
        shown = true;
        break;
      }
    }
    if (shown == false) {
      $(".business_step3").show();
    }
  });
  $(".btn_step0").on('click', function() { $(".business_step").hide(); $(".business_step0").show(); window.scrollTo(0,0); });
  $(".btn_step2").on('click', function() { $(".business_step").hide(); $(".business_step2").show(); window.scrollTo(0,0); });
  $(".btn_step21").on('click', function(e) {
    $(".business_step").hide();
    var skip = true;
    var step2_cc = Cookies.get("complect_step2");
    if (step2_cc != undefined) {
      var step2_c = step2_cc.split("-");
      for (kookie of step2_c) {
        if (sub_inds.indexOf(parseInt(kookie)) > -1) {
          skip = false;
        }
      }
    }
    if (skip == true)  {
      if ($(this).hasClass("back")) {
        $(".business_step2").show();
      } else {
        $(".business_step3").show();
      }
    } else {
      $(".business_step21").show();
      render_step21();
    }

    e.preventDefault();
    e.stopPropagation();
    window.scrollTo(0,0);
  });

  $(".btn_step1").on('click', function() { $(".business_step").hide(); $(".business_step1").show(); window.scrollTo(0,0); });
  $(".btn_step3").on('click', function() { $(".business_step").hide(); $(".business_step3").show(); window.scrollTo(0,0); });
  $(".btn_step4").on('click', function() { $(".business_step").hide(); $(".business_step4").show(); window.scrollTo(0,0); });
  $(".btn_step5").on('click', function() {
    var show_products = false;
    for (industry_id of Cookies.get("complect_step2").split("-")) {
      if (parseInt(industry_id) == ria_industry) {
        show_products = true;
      }
    }
    if (show_products) {
      $(".business_step").hide();
      $(".business_step5").show();
    } else {
      $("#new_business").submit();
    }
  });
  $(".btn_step6").on('click', function() {
    $("#new_business").submit();
  });

  $(".signup_products .product").on("click", function() {
    $(".signup_products .product").removeClass("active");
    $(this).addClass("active");
    Cookies.set("complect_step4", $(this).attr("data-product"));
    $(".btn_step6").prop("disabled", false);
  });



  $("#business_user_attributes_password, #business_contact_first_name, #business_contact_last_name, #business_user_attributes_email, "+required_fields_step0.join(", ")).on('keydown', function(e) {
    if (e.keyCode == 13) {
      e.preventDefault;
      step_signup_continue();
      if ($(".business_step0 .continue").prop("disabled") == false) {
        $(".btn_step_jump").trigger('click');
      }
      return false;
    }
  });

  $("#specify_other").on("keyup", function() {
    Cookies.set('complect_other', $(this).val(), { expires: 7 });
    if ($(this).val().length > 0) {
      $(this).parent().find("span").html("Other ("+$(this).val()+")");
    } else {
      $(this).parent().find("span").html("Other");
    }
  });

  var toggle_choices = function(t_choice) {
    // identify step with parent div
    var parent = t_choice.parent().parent().parent();
    // checking / unchecking and cosmetic stuff for 'i_dunno' and 'other (...)'
    var cb = t_choice.find("input[type='checkbox']");
    if (t_choice.hasClass("active")) {
      t_choice.removeClass("active");
      cb.prop("checked", false);
    } else {
      if (t_choice.text().indexOf("Other") > -1) {
        $("#specify_other").show();
        $("#specify_other").focus();
      }
      if (t_choice.text().indexOf("I don't know") > -1) {
        _Modal.showPlain("<div class='bootbox-heading p-x-3'>Schedule Consultation<hr/></div><div class='p-x-3 m-x-3 m-t-2 p-b-3 text-center'>We understand this can be a confusing process <br> and we want to make it as easy as possible.<br>So, let’s set you up with a free consultation.<div class='m-b-1 m-t-2 text-center'><a href='https://calendly.com/complect' target='_blank' class='btn btn-primary' style='width: 140px;'>Schedule</a></div>");
      } else {
        t_choice.addClass("active");
        cb.prop("checked", true);
      }
    }

    for (var name of ["step2", "step1", "step21"]) {
      nums = [];
      actives = $(".business_"+name+" .active");
      for (var act of actives) {
        nums.push($(act).find("input").val());
      }
      if (parent.hasClass("business_"+name)) {
        if (name == "step2") { render_step21(); };
        Cookies.set("complect_"+name, nums.join("-"), { expires: 7 });
      }
    }

    for (var name of step_names) {
      if ((name != "step2") && (name != "step1") && (name != "step21")) {
        nums = [];
        actives = $(".business_"+name+" .active");
        for (var act of actives) {
          nums.push($(".business_"+name+" .btn-block").index(act));
        }
        if (parent.hasClass("business_"+name)) {
          Cookies.set("complect_"+name, nums.join("-"), { expires: 7 });
        }
      }
    }
    step_signup_continue();
  }

  $(".choices").on('click', '.btn-block', function(e) {
    e.preventDefault();
    toggle_choices($(this));
  });

  $(".choices").on('click', "input[type='checkbox']", function(e) {
    e.stopPropagation();
    var checked = $(this).prop("checked");
    if (checked) {
      $(this).parent().removeClass("active");
      var parent = $(this).parent().parent().parent().parent();
    } else {
      $(this).parent().addClass("active");
    }
    if (toggle_choices($(this).parent()) == false) {
      $(this).prop("checked", false);
    }
  });
}

if ((window.location.pathname.indexOf("/business/onboarding") > -1)) {
  $(document).ready(function() {
    $(".signup_products .product").on("click", function() {
      $(".signup_products .product").removeClass("active");
      $(this).addClass("active");
      $("#onboarding_business_stages").val($(this).attr("data-product"));
    });
    $(".pos_total_annual").hide();
    $("#checkout_schedule_monthly, #checkout_schedule_annual").on("change", function() {
      if ($(this).val() == "annual") {
        $(".pos_total").hide();
        $(".pos_total_annual").show();
        $(".on_going_cost").html("$1000");
      }
      if ($(this).val() == "monthly") {
        $(".pos_total").show();
        $(".pos_total_annual").hide();
        $(".on_going_cost").html("$100");
      }
    })
    if (typeof(trigger_monthly_sub) != "undefined") {
      $("#checkout_schedule_monthly").trigger("click");
    }
  });
}
