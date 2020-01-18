if ((window.location.pathname == "/businesses/new") || ($("body").hasClass("businesses") && $("body").hasClass("create"))) {
  var no_pwd_focus = false;
  var pwd_focused = false;
  var step_names = ['step0', 'step1', 'step11', 'step2', 'step3', 'step4', 'step41', 'step42', 'step5'];
  var step_cookies = {};

  function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  $(document).ready(function() {
    for (var name of step_names) {
      step_cookies[name] = Cookies.get('complect_'+name);
    }

    $("#business_user_attributes_email").val(Cookies.get("complect_email"));
    $("#business_contact_first_name").val(Cookies.get("complect_first_name"));
    $("#business_contact_last_name").val(Cookies.get("complect_last_name"));
    $(".business_step0").show();
    calc_steps();
    var other = Cookies.get("complect_other");
    if (other != undefined) {
      for (var choice of $(".business_step1 .btn-block")) {
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
      if ((step_cookies[name] != undefined) && (name != "step2") && (name != "step1") && (name != "step11")) {
        for (var num of step_cookies[name].split("-")) {
          var choice = $($(".business_"+name+" .btn-block")[parseInt(num)]);
          choice.addClass("active");
          choice.find("input[type=checkbox]").prop("checked", true);
        }
      }
    }

    if ((step_cookies["step1"] != undefined) && (step_cookies["step1"].length > 0)) {
      for (var num of step_cookies["step1"].split("-")) {
        var choice = $(".business_step1 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
      render_step11();
    }

    if ((step_cookies["step2"] != undefined) && (step_cookies["step2"].length > 0)) {
      for (var num of step_cookies["step2"].split("-")) {
        var choice = $(".business_step2 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_continue();
  });

  function calc_steps() {
    var s1_c = Cookies.get("complect_step1");
    var skip2 = false;
    if ((s1_c != undefined) && (s1_c.length > 0)) {
      var step1_c = s1_c.split("-");
      for (kookie of step1_c) {
        if (consulting_recruiter.indexOf(parseInt(kookie)) > -1) {
          skip2 = true;
        }
      }
      if (skip2 == true) {
        $(".src_step").hide();
        $(".alt_step").show();
      } else {
        $(".src_step").show();
        $(".alt_step").hide();
      }
    } else {
      $(".src_step").show();
      $(".alt_step").hide();
    }
    return skip2;
  }

  function render_step11() {
    var nums = [];
    var cookies_step1 = Cookies.get('complect_step1');
    if ((cookies_step1 != undefined) && (cookies_step1.length > 0)) {
      for (var num of cookies_step1.split("-")) {
        nums.push(parseInt(num));
      }
    }

    $(".business_step11 .choices .col-sm-12").hide();
    for (var num of nums) {
      var cb = $(".business_step1 .choices input[value="+num+"]");
      var cb_txt = cb.parent().text();
      $(".business_step11 .choices .col-sm-12").each(function() {
        if (parseInt($(this).find("input[type=checkbox]").val().split("_")[0]) == num) {
          $(this).show();
        }
      });
    }
    nums = Cookies.get("complect_step11");
    if ((nums != undefined) && (nums.length > 0)) {
      for (var num of nums.split("-")) {
        var active_btn = $(".business_step11 .choices input[value="+num+"]").parent();
        active_btn.addClass("active");
        active_btn.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_continue();
  }

  $("#business_user_attributes_email").on('keyup', function(e) {
    if (validateEmail($(this).val())) {
      $(this).removeClass("form_error");
    } else {
      $(this).addClass("form_error");
    }
    Cookies.set("complect_email", $(this).val(), { expires: 7 });
    no_pwd_focus = true;
    step_continue();
  });

  $("#business_contact_first_name").on('keyup', function(e) {
    Cookies.set("complect_first_name", $(this).val(), { expires: 7 });
    step_continue();
  });

  $("#business_contact_last_name").on('keyup', function(e) {
    Cookies.set("complect_last_name", $(this).val(), { expires: 7 });
    step_continue();
  });

  $("#business_user_attributes_password").on('keyup', function() {
    step_continue();
  });

  $(".btn_step_jump").on('click', function() {
    $(".business_step").hide();
    var shown = false;
    for (var i = 1; i < step_names.length; i++) {
      var name = step_names[i];
      console.log(name);
      console.log(step_cookies[name]);
      if (step_cookies[name] == undefined) {
        if (name == "step11") {
          $(".business_step1").show();
          shown = true;
          break;
        } else if (name == "step3") {
          $(".business_step2").show();
          shown = true;
          break;
        } else {
          $(".business_"+step_names[i]).show();
          shown = true;
          break;
        }
      }
    }
    if (shown == false) {
      $(".business_step1").show();
    }
  });
  $(".btn_step0").on('click', function() { $(".business_step").hide(); $(".business_step0").show(); window.scrollTo(0,0); });
  $(".btn_step1").on('click', function() { $(".business_step").hide(); $(".business_step1").show(); window.scrollTo(0,0); });
  $(".btn_step11").on('click', function(e) {
    $(".business_step").hide();
    var skip = true;
    var step1_cc = Cookies.get("complect_step1");
    if (step1_cc != undefined) {
      var step1_c = step1_cc.split("-");
      for (kookie of step1_c) {
        if (sub_inds.indexOf(parseInt(kookie)) > -1) {
          skip = false;
        }
      }
    }
    if (skip == true)  {
      if ($(this).hasClass("back")) {
        $(".business_step1").show();
      } else {
        $(".business_step2").show();
      }
    } else {
      $(".business_step11").show();
      render_step11();
    }

    e.preventDefault();
    e.stopPropagation();
    window.scrollTo(0,0);
  });

  $(".btn_step2").on('click', function() { $(".business_step").hide(); $(".business_step2").show(); window.scrollTo(0,0); });
  $(".btn_step3").on('click', function() { 
    $(".business_step").hide();
    if (calc_steps() == true) {
      if ($(this).hasClass("back")) {
        $(".business_step2").show();
      } else {
        $(".business_step4").show();
      }
    } else {
      $(".business_step3").show();
    }
    window.scrollTo(0,0);
   });
  $(".btn_step4").on('click', function() { $(".business_step").hide(); $(".business_step4").show(); window.scrollTo(0,0); });
  $(".btn_step41").on('click', function() { $(".business_step").hide(); $(".business_step41").show(); window.scrollTo(0,0); });
  $(".btn_step42").on('click', function() { $(".business_step").hide(); $(".business_step42").show(); window.scrollTo(0,0); });
  $(".btn_step5").on('click', function() { $(".business_step").hide(); $(".business_step5").show(); window.scrollTo(0,0); });
  $(".btn_step6").on('click', function() { $(".business_step").hide(); $(".business_step6").show(); window.scrollTo(0,0); });

  function step_continue() {
    for (var name of step_names) {
      if (name == "step0") {
        $(".business_step0 .continue").prop("disabled", true);
        if (validateEmail($("#business_user_attributes_email").val())) {
          if ($("#business_user_attributes_password").val().length > 5) {
            $("#business_user_attributes_password").removeClass("form_error");
            if ($("#business_contact_first_name").val().length > 0) {
              if ($("#business_contact_last_name").val().length > 0) {
                $(".business_step0 .continue").prop("disabled", false);
              }
            }
          } else {
            $("#business_user_attributes_password").addClass("form_error");
            if ((pwd_focused == false) && (no_pwd_focus == false)) {
              pwd_focused = true;
              $("#business_user_attributes_password").focus();
            }
          }
        }
      } else {
        if (name != "step5") {
          $(".business_"+name).find(".continue").prop("disabled", !($(".business_"+name+" .choices .active").length > 0));
        }
      }
    }
  }

  $("#business_user_attributes_password, #business_contact_first_name, #business_contact_last_name, #business_user_attributes_email").on('keydown', function(e) {
    if (e.keyCode == 13) {
      e.preventDefault;
      step_continue();
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

  function toggle_choice(choice) {
    // identify step with parent div
    var parent = choice.parent().parent().parent();
    // force only 1 checkbox rule for risk questions
    if ((parent.hasClass("business_step4")) || (parent.hasClass("business_step41")) || (parent.hasClass("business_step42"))) {
      var all = parent.find(".btn-block");
      all.removeClass("active");
      for (var al of all) {
        $(al).find("input[type=checkbox]").prop("checked", false);
      }
    }

    // checking / unchecking and cosmetic stuff for 'i_dunno' and 'other (...)'
    var cb = choice.find("input[type='checkbox']");
    if (choice.hasClass("active")) {
      choice.removeClass("active");
      cb.prop("checked", false);
    } else {
      if (choice.text().indexOf("Other") > -1) {
        $("#specify_other").focus();
      }
      if (choice.text().indexOf("I don't know") > -1) {
        _Modal.showPlain("<div class='modal-body'><div class='modal-fake text-center modal-wrapper m-x-1 m-y-1 p-t-2 p-x-3 gray'>We understand this can be a confusing process and <br> we want to make it as easy as possible, so let’s set you up with a free consultation.<br>Schedule a time to speak to someone. <div class='m-b-1 m-t-2'><button class='btn btn-default' data-dismiss='modal'>Cancel</button> <a href='https://calendly.com/complect' target='_blank' class='btn btn-primary'>Schedule</a></div></div>");
      } else {
        choice.addClass("active");
        cb.prop("checked", true);
      }
    }

    for (var name of ["step1", "step2", "step11"]) {
      nums = [];
      actives = $(".business_"+name+" .active");
      for (var act of actives) {
        nums.push($(act).find("input").val());
      }
      if (parent.hasClass("business_"+name)) {
        if (name == "step1") { render_step11(); };
        console.log(nums);
        Cookies.set("complect_"+name, nums.join("-"), { expires: 7 });
      }
    }

    for (var name of step_names) {
      if ((name != "step1") && (name != "step2") && (name != "step11")) {
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
    step_continue();
    calc_steps();
  }

  $(".choices").on('click', '.btn-block', function() {
    toggle_choice($(this));
  });

  $(".choices").on('click', "input[type='checkbox']", function(e) {
    e.stopPropagation();
    var checked = $(this).prop("checked");
    if (checked) {
      $(this).parent().removeClass("active");
      var parent = $(this).parent().parent().parent().parent();
      console.log(parent);
      if ((parent.hasClass("business_step4")) || (parent.hasClass("business_step41")) || (parent.hasClass("business_step42"))) {
        var all = parent.find(".btn-block");
        all.removeClass("active");
        for (var al of all) {
          $(al).find("input[type=checkbox]").prop("checked", false);
        }
      }
    } else {
      $(this).parent().addClass("active");
    }
    if (toggle_choice($(this).parent()) == false) {
      $(this).prop("checked", false);
    }
  });
}