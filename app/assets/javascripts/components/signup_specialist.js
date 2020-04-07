if ((window.location.pathname == "/specialists/new") || ($("body").hasClass("specialists") && $("body").hasClass("create"))) {
  var no_pwd_focus = false;
  var pwd_focused = false;
  var step_names = ['step0', 'step1', 'step2', 'step21', 'step3', 'step4'];
  var step_cookies = {};
  var required_fields_step0 = ["#specialist_user_attributes_password", "#specialist_first_name", "#specialist_last_name", "#specialist_user_attributes_email", "#specialist_user_attributes_password_confirmation", "#specialist_address_1", "#specialist_city", "#specialist_state", "#specialist_zipcode", "#specialist_country", "#specialist_time_zone"];
  var cookie_form_attrs = ["#specialist_first_name", "#specialist_last_name", "#specialist_user_attributes_email", "#specialist_address_1", "#specialist_city", "#specialist_state", "#specialist_zipcode", "#specialist_address_2"];

  function sub_jur_other_toggle() {
    if ($(".specialist_step1 .choices button[data-other='yes'] input:checked").length > 0) {
      $("#sub_jur_other").show();
    } else {
      $("#sub_jur_other").hide();
    }
  }

  function step_signup_continue() {
    for (var name of step_names) {
      if (name == "step0") {
        $(".specialist_step0 .continue").prop("disabled", true);
        if (validateEmail($("#specialist_user_attributes_email").val())) {
          if ($("#specialist_user_attributes_password").val().length > 5) {
            $("#specialist_user_attributes_password").removeClass("form_error");
            var prop_disabled = false;
            if ($("#specialist_user_attributes_password").val() != $("#specialist_user_attributes_password_confirmation").val()) {
              $("#specialist_user_attributes_password_confirmation").addClass("form_error");
              console.log("pwd fail");
              prop_disabled = true;
            } else {
              $("#specialist_user_attributes_password_confirmation").removeClass("form_error");
            }
            for (field of required_fields_step0) {
              if (!($(field).val().length > 0)) {
                console.log("just fail");
                console.log(field);
                prop_disabled = true;
              }
            }
            $(".specialist_step0 .continue").prop("disabled", prop_disabled);
          } else {
            $("#specialist_user_attributes_password").addClass("form_error");
            if ((pwd_focused == false) && (no_pwd_focus == false)) {
              pwd_focused = true;
              $("#specialist_user_attributes_password").focus();
            }
          }
        }
      } else {
        if (name != "step4") {
          $(".specialist_"+name).find(".continue").prop("disabled", !($(".specialist_"+name+" .choices .active").length > 0));
        }
      }
    }
  }

  function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  $(document).ready(function() {
    function num_to_opinion(n) {
      return ["strongly<br>disagree", "somewhat disagree", "I don't know", "somewhat agree", "strongly<br>agree"][n-1];
    }

    for (var name of step_names) {
      step_cookies[name] = Cookies.get('complect_s_'+name);
    }

    if (typeof(step_cookies["step4"]) == "undefined") {
      step_cookies["step4"] = "3-3-3";
      Cookies.set("complect_s_step4", "3-3-3");
    }

    function set_risks_cookie() {
      Cookies.set("complect_s_step4", $("#specialist_risks_1").val()+"-"+$("#specialist_risks_2").val()+"-"+$("#specialist_risks_3").val());
    }

    $("#specialist_risks_1").ionRangeSlider({
      grid: false,
      from: step_cookies["step4"].split("-")[0],
      min: 1,
      max: 5,
      prettify: num_to_opinion,
      onChange: function(data) {
        set_risks_cookie();
      }
    });

    $("#specialist_risks_2").ionRangeSlider({
      grid: false,
      from: step_cookies["step4"].split("-")[1],
      min: 1,
      max: 5,
      prettify: num_to_opinion,
      onChange: function(data) {
        set_risks_cookie();
      }
    });

    $("#specialist_risks_3").ionRangeSlider({
      grid: false,
      from: step_cookies["step4"].split("-")[2],
      min: 1,
      max: 5,
      prettify: num_to_opinion,
      onChange: function(data) {
        set_risks_cookie();
      }
    });

    for (cookie_attr of cookie_form_attrs) {
      $(cookie_attr).val(Cookies.get(cookie_attr.replace("#specialist_", "complect_s_")));
    }

    $(".specialist_step0").show();
    var other = Cookies.get("complect_s_other");
    if (other != undefined) {
      for (var choice of $(".specialist_step2 .btn-block")) {
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
    var jur_other = Cookies.get("complect_s_jur_other");
    if (jur_other != undefined) {
      $("#sub_jurisdiction_other").val(jur_other);
    }
    var states_usa = Cookies.get("complect_s_states_usa");
    if (states_usa != undefined) {
      $("#specialist_jurisdiction_states_usa").val(Cookies.get("complect_s_states_usa").split("-"));
    }
    var states_canada = Cookies.get("complect_s_states_canada");
    if (states_canada != undefined) {
      $("#specialist_jurisdiction_states_canada").val(Cookies.get("complect_s_states_canada").split("-"));
    }


    $("#specify_other").hide();

    for (var name of step_names) {
      if ((step_cookies[name] != undefined) && (name != "step1") && (name != "step2") && (name != "step21") && (name != "step3")) {
        for (var num of step_cookies[name].split("-")) {
          var choice = $($(".specialist_"+name+" .btn-block")[parseInt(num)]);
          choice.addClass("active");
          choice.find("input[type=checkbox]").prop("checked", true);
        }
      }
    }

    if ((step_cookies["step2"] != undefined) && (step_cookies["step2"].length > 0)) {
      for (var num of step_cookies["step2"].split("-")) {
        var choice = $(".specialist_step2 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
      render_step21();
    }

    if ((step_cookies["step1"] != undefined) && (step_cookies["step1"].length > 0)) {
      for (var num of step_cookies["step1"].split("-")) {
        var choice = $(".specialist_step1 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_signup_continue();
    render_step3();
    sub_jur_other_toggle();
  });

  function render_step21() {
    var nums = [];
    var cookies_step2 = Cookies.get('complect_s_step2');
    if ((cookies_step2 != undefined) && (cookies_step2.length > 0)) {
      for (var num of cookies_step2.split("-")) {
        nums.push(parseInt(num));
      }
    }

    $(".specialist_step21 .choices .col-sm-12").hide();
    for (var num of nums) {
      var cb = $(".specialist_step2 .choices input[value="+num+"]");
      var cb_txt = cb.parent().text();
      $(".specialist_step21 .choices .col-sm-12").each(function() {
        if (parseInt($(this).find("input[type=checkbox]").val().split("_")[0]) == num) {
          $(this).show();
        }
      });
    }
    nums = Cookies.get("complect_s_step21");
    if ((nums != undefined) && (nums.length > 0)) {
      for (var num of nums.split("-")) {
        var active_btn = $(".specialist_step21 .choices input[value="+num+"]").parent();
        active_btn.addClass("active");
        active_btn.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_signup_continue();
  }

  function render_step3() {
    var nums = [];
    var cookies_step1 = Cookies.get('complect_s_step1');
    if ((cookies_step1 != undefined) && (cookies_step1.length > 0)) {
      for (var num of cookies_step1.split("-")) {
        nums.push(parseInt(num));
      }
    }

    $(".specialist_step3 .choices .col-sm-12").hide();
    for (var num of nums) {
      var cb = $(".specialist_step3 .choices input[value="+num+"]");
      var cb_txt = cb.parent().text();
      $(".specialist_step3 .choices .col-sm-12").each(function() {
        if (parseInt($(this).find("input[type=checkbox]").val().split("_")[0]) == num) {
          $(this).show();
        }
      });
    }
    nums = Cookies.get("complect_s_step3");
    if ((nums != undefined) && (nums.length > 0)) {
      for (var num of nums.split("-")) {
        var active_btn = $(".specialist_step3 .choices input[value="+num+"]").parent();
        active_btn.addClass("active");
        active_btn.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_signup_continue();
  }

  $("#specialist_user_attributes_email").on('keyup', function(e) {
    if (validateEmail($(this).val())) {
      $(this).removeClass("form_error");
    } else {
      $(this).addClass("form_error");
    }
    Cookies.set("complect_s_email", $(this).val(), { expires: 7 });
    no_pwd_focus = true;
    step_signup_continue();
  });

  $(cookie_form_attrs.join(", ")).on('keyup', function(e) {
    //console.log(this);
    Cookies.set($(this).attr('id').replace("specialist_", "complect_s_"), $(this).val(), { expires: 7 });
    step_signup_continue();
  });

  $("#specialist_user_attributes_password, "+required_fields_step0.join(", ")).on('keyup', function() {
    step_signup_continue();
  });

  $("#specialist_user_attributes_password, "+required_fields_step0.join(", ")).on('change', function() {
    step_signup_continue();
  });

  $(".btn_step_jump").on('click', function() {
    $(".specialist_step").hide();
    var shown = false;
    for (var i = 1; i < 6; i++) {
      var name = step_names[i];
      console.log(name);
      console.log(step_cookies[name]);
      if (step_cookies[name] == undefined) {
        if ((name == "step21") || (name == "step2")) {
          console.log("SHOWING STEP2");
          $(".specialist_step2").show();
          shown = true;
          break;
        } else if (name == "step3") {
          $(".specialist_step1").show();
          shown = true;
          break;
        } else {
          $(".specialist_"+step_names[i]).show();
          shown = true;
          break;
        }
      }
    }
    if (shown == false) {
      $(".specialist_step3").show();
    }
    sub_jur_other_toggle();
  });


  $(".btn_step0").on('click', function() { $(".specialist_step").hide(); $(".specialist_step0").show(); window.scrollTo(0,0); });
  $(".btn_step2").on('click', function() { $(".specialist_step").hide(); $(".specialist_step2").show(); window.scrollTo(0,0); });
  $(".btn_step21").on('click', function(e) {
    $(".specialist_step").hide();
    var skip = true;
    var step2_cc = Cookies.get("complect_s_step2");
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
        $(".specialist_step2").show();
      } else {
        $(".specialist_step3").show();
      }
    } else {
      $(".specialist_step21").show();
      render_step21();
    }
    sub_jur_other_toggle();
    e.preventDefault();
    e.stopPropagation();
    window.scrollTo(0,0);
  });

  $(".btn_step1").on('click', function() { $(".specialist_step").hide(); $(".specialist_step1").show(); window.scrollTo(0,0); });
  $(".btn_step3").on('click', function() {
    $(".specialist_step").hide();
    $(".specialist_step3").show();
    render_step3();
    sub_jur_other_toggle();
    window.scrollTo(0,0);
   });
  $(".btn_step31").on('click', function() { $(".specialist_step").hide(); $(".specialist_step31").show(); window.scrollTo(0,0); });
  $(".btn_step32").on('click', function() { $(".specialist_step").hide(); $(".specialist_step32").show(); window.scrollTo(0,0); });
  $(".btn_step4").on('click', function() { $(".specialist_step").hide(); $(".specialist_step4").show(); window.scrollTo(0,0); });
  $(".btn_step5").on('click', function() { $(".specialist_step").hide(); $(".specialist_step5").show(); window.scrollTo(0,0); });
  $(".btn_step6").on('click', function() { $(".specialist_step").hide(); $(".specialist_step6").show(); window.scrollTo(0,0); });
  $(".btn_step7").on('click', function() { $(".specialist_step").hide(); $(".specialist_step7").show(); window.scrollTo(0,0); });
  $(".btn_step8").on('click', function() { $(".specialist_step").hide(); $(".specialist_step8").show(); window.scrollTo(0,0); });

  $(required_fields_step0.join(", ")).on('keydown', function(e) {
    if (e.keyCode == 13) {
      e.preventDefault;
      step_signup_continue();
      if ($(".specialist_step0 .continue").prop("disabled") == false) {
        $(".btn_step_jump").trigger('click');
      }
      return false;
    }
  });

  $("#business_user_attributes_password, "+required_fields_step0.join(", ")).on('keyup', function() {
    step_signup_continue();
  });

  $("#specialist_jurisdiction_states_usa").on("change", function() {
    Cookies.set("complect_s_states_usa", $(this).val().join("-"), { expires: 7});
  })

  $("#specialist_jurisdiction_states_canada").on("change", function() {
    Cookies.set("complect_s_states_canada", $(this).val().join("-"), { expires: 7});
  })

  $("#specify_other").on("keyup", function() {
    Cookies.set('complect_s_other', $(this).val(), { expires: 7 });
    if ($(this).val().length > 0) {
      $(this).parent().find("span").html("Other ("+$(this).val()+")");
    } else {
      $(this).parent().find("span").html("Other");
    }
  });

  $("#sub_jurisdiction_other").on("keyup", function() {
    Cookies.set('complect_s_jur_other', $(this).val(), { expires: 7 });
  });

  function toggle_choices(t_choice) {
    // identify step with parent div
    var parent = t_choice.parent().parent().parent();
    console.log("tchoice");
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
        _Modal.showPlain("<div class='modal-body'><div class='modal-fake text-center modal-wrapper m-x-1 m-y-1 p-t-2 p-x-3 gray'>We understand this can be a confusing process and <br> we want to make it as easy as possible, so let’s set you up with a free consultation.<br>Schedule a time to speak to someone. <div class='m-b-1 m-t-2'><button class='btn btn-default' data-dismiss='modal'>Cancel</button> <a href='https://calendly.com/complect' target='_blank' class='btn btn-primary'>Schedule</a></div></div>");
      } else {
        var dont_check = false;
        if (parent.hasClass("specialist_step7")) {
          var all = parent.find(".btn-block.active");
          if (all.length > 4) {
            dont_check = true;
          }
        }
        if (dont_check == false) {
          t_choice.addClass("active");
          cb.prop("checked", true);
        } else {
          cb.prop("checked", false);
        }
      }
    }

    for (var name of ["step2", "step1", "step21", "step3"]) {
      nums = [];
      actives = $(".specialist_"+name+" .active");
      for (var act of actives) {
        nums.push($(act).find("input").val());
      }
      if (parent.hasClass("specialist_"+name)) {
        if (name == "step2") { render_step21(); };
        if (name == "step1") { render_step3(); };
        console.log(nums);
        Cookies.set("complect_s_"+name, nums.join("-"), { expires: 7 });
      }
    }

    for (var name of step_names) {
      if ((name != "step2") && (name != "step1") && (name != "step21") && (name != "step3")) {
        nums = [];
        actives = $(".specialist_"+name+" .active");
        for (var act of actives) {
          nums.push($(".specialist_"+name+" .btn-block").index(act));
        }
        if (parent.hasClass("specialist_"+name)) {
          Cookies.set("complect_s_"+name, nums.join("-"), { expires: 7 });
        }
      }
    }

    step_signup_continue();
    sub_jur_other_toggle();
  }

  $(".choices").on('click', '.btn-block', function(e) {
    e.preventDefault();
    if ($(e.target).attr("id") != "sub_jurisdiction_other") {
      toggle_choices($(this));
    }
  });

  $(".choices").on('click', "input[type='checkbox']", function(e) {
    e.stopPropagation();
    var checked = $(this).prop("checked");
    if (checked) {
      $(this).parent().removeClass("active");
      var parent = $(this).parent().parent().parent().parent();
      console.log(parent);
      if ((parent.hasClass("specialist_step3")) || (parent.hasClass("specialist_step31")) || (parent.hasClass("specialist_step32"))) {
        var all = parent.find(".btn-block");
        all.removeClass("active");
        for (var al of all) {
          $(al).find("input[type=checkbox]").prop("checked", false);
        }
      }
    } else {
      $(this).parent().addClass("active");
    }
    if (toggle_choices($(this).parent()) == false) {
      $(this).prop("checked", false);
    }
  });
}