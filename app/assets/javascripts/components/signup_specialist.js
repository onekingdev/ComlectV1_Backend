if ((window.location.pathname == "/specialists/new") || ($("body").hasClass("specialists") && $("body").hasClass("create"))) {
  var no_pwd_focus = false;
  var pwd_focused = false;
  var step_names = ['step0', 'step1', 'step11', 'step2', 'step3', 'step31', 'step32'];
  var step_cookies = {};

  function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  $(document).ready(function() {
    for (var name of step_names) {
      step_cookies[name] = Cookies.get('complect_s_'+name);
    }

    $("#specialist_user_attributes_email").val(Cookies.get("complect_s_email"));
    $("#specialist_first_name").val(Cookies.get("complect_s_first_name"));
    $("#specialist_last_name").val(Cookies.get("complect_s_last_name"));
    $(".specialist_step0").show();
    var other = Cookies.get("complect_s_other");
    if (other != undefined) {
      for (var choice of $(".specialist_step1 .btn-block")) {
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
          var choice = $($(".specialist_"+name+" .btn-block")[parseInt(num)]);
          choice.addClass("active");
          choice.find("input[type=checkbox]").prop("checked", true);
        }
      }
    }

    if ((step_cookies["step1"] != undefined) && (step_cookies["step1"].length > 0)) {
      for (var num of step_cookies["step1"].split("-")) {
        var choice = $(".specialist_step1 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
      render_step11();
    }

    if ((step_cookies["step2"] != undefined) && (step_cookies["step2"].length > 0)) {
      for (var num of step_cookies["step2"].split("-")) {
        var choice = $(".specialist_step2 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_continue();
  });

  function render_step11() {
    var nums = [];
    var cookies_step1 = Cookies.get('complect_s_step1');
    if ((cookies_step1 != undefined) && (cookies_step1.length > 0)) {
      for (var num of cookies_step1.split("-")) {
        nums.push(parseInt(num));
      }
    }

    $(".specialist_step11 .choices .col-sm-12").hide();
    for (var num of nums) {
      var cb = $(".specialist_step1 .choices input[value="+num+"]");
      var cb_txt = cb.parent().text();
      $(".specialist_step11 .choices .col-sm-12").each(function() {
        if (parseInt($(this).find("input[type=checkbox]").val().split("_")[0]) == num) {
          $(this).show();
        }
      });
    }
    nums = Cookies.get("complect_s_step11");
    if ((nums != undefined) && (nums.length > 0)) {
      for (var num of nums.split("-")) {
        var active_btn = $(".specialist_step11 .choices input[value="+num+"]").parent();
        active_btn.addClass("active");
        active_btn.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_continue();
  }

  $("#specialist_user_attributes_email").on('keyup', function(e) {
    if (validateEmail($(this).val())) {
      $(this).removeClass("form_error");
    } else {
      $(this).addClass("form_error");
    }
    Cookies.set("complect_s_email", $(this).val(), { expires: 7 });
    no_pwd_focus = true;
    step_continue();
  });

  $("#specialist_first_name").on('keyup', function(e) {
    Cookies.set("complect_s_first_name", $(this).val(), { expires: 7 });
    step_continue();
  });

  $("#specialist_last_name").on('keyup', function(e) {
    Cookies.set("complect_s_last_name", $(this).val(), { expires: 7 });
    step_continue();
  });

  $("#specialist_user_attributes_password").on('keyup', function() {
    step_continue();
  });

  $(".btn_step_jump").on('click', function() {
    $(".specialist_step").hide();
    var shown = false;
    for (var i = step_names.length; i > 0; i--) {
      var name = step_names[i];
      console.log(name);
      console.log(step_cookies[name]);
      if ((step_cookies[name] != undefined) && (step_cookies[name].length > 0)) {
        if (name == "step11") {
          $(".specialist_step1").show();
          shown = true;
          break;
        } else if (name == "step3") {
          $(".specialist_step2").show();
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
      $(".specialist_step1").show();
    }
  });
  $(".btn_step0").on('click', function() { $(".specialist_step").hide(); $(".specialist_step0").show(); window.scrollTo(0,0); });
  $(".btn_step1").on('click', function() { $(".specialist_step").hide(); $(".specialist_step1").show(); window.scrollTo(0,0); });
  $(".btn_step11").on('click', function(e) {
    $(".specialist_step").hide();
    var skip = true;
    var step1_c = Cookies.get("complect_s_step1").split("-");
    for (kookie of step1_c) {
      if (sub_inds.indexOf(parseInt(kookie)) > -1) {
        skip = false;
      }
    }
    if (skip == true)  {
      if ($(this).hasClass("back")) {
        $(".specialist_step1").show();
      } else {
        $(".specialist_step2").show();
      }
    } else {
      $(".specialist_step11").show();
      render_step11();
    }

    e.preventDefault();
    e.stopPropagation();
    window.scrollTo(0,0);
  });

  $(".btn_step2").on('click', function() { $(".specialist_step").hide(); $(".specialist_step2").show(); window.scrollTo(0,0); });
  $(".btn_step3").on('click', function() { 
    $(".specialist_step").hide();
    $(".specialist_step3").show();
    window.scrollTo(0,0);
   });
  $(".btn_step4").on('click', function() { $(".specialist_step").hide(); $(".specialist_step4").show(); window.scrollTo(0,0); });
  $(".btn_step41").on('click', function() { $(".specialist_step").hide(); $(".specialist_step41").show(); window.scrollTo(0,0); });
  $(".btn_step42").on('click', function() { $(".specialist_step").hide(); $(".business_step42").show(); window.scrollTo(0,0); });
  $(".btn_step5").on('click', function() { $(".specialist_step").hide(); $(".specialist_step5").show(); window.scrollTo(0,0); });
  $(".btn_step6").on('click', function() { $(".specialist_step").hide(); $(".specialist_step6").show(); window.scrollTo(0,0); });

  function step_continue() {
    for (var name of step_names) {
      if (name == "step0") {
        $(".specialist_step0 .continue").prop("disabled", true);
        if (validateEmail($("#specialist_user_attributes_email").val())) {
          if ($("#specialist_user_attributes_password").val().length > 5) {
            $("#specialist_user_attributes_password").removeClass("form_error");
            if ($("#specialist_first_name").val().length > 0) {
              if ($("#specialist_last_name").val().length > 0) {
                $(".specialist_step0 .continue").prop("disabled", false);
              }
            }
          } else {
            $("#specialist_user_attributes_password").addClass("form_error");
            if ((pwd_focused == false) && (no_pwd_focus == false)) {
              pwd_focused = true;
              $("#specialist_user_attributes_password").focus();
            }
          }
        }
      } else {
        if (name != "step5") {
          $(".specialist_"+name).find(".continue").prop("disabled", !($(".specialist_"+name+" .choices .active").length > 0));
        }
      }
    }
  }

  $("#specialist_user_attributes_password, #specialist_first_name, #specialist_last_name, #specialist_user_attributes_email").on('keydown', function(e) {
    if (e.keyCode == 13) {
      e.preventDefault;
      step_continue();
      if ($(".specialist_step0 .continue").prop("disabled") == false) {
        $(".btn_step_jump").trigger('click');
      }
      return false;
    }
  });

  $("#specify_other").on("keyup", function() {
    Cookies.set('complect_s_other', $(this).val(), { expires: 7 });
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
    if ((parent.hasClass("specialist_step4")) || (parent.hasClass("specialist_step41")) || (parent.hasClass("specialist_step42"))) {
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
        _Modal.showPlain("<div class='modal-body'><div class='modal-fake text-center modal-wrapper m-x-1 m-y-1 p-t-2 p-x-3 gray'>We understand this can be a confusing process and <br> we want to make it as easy as possible, so let’s set you up with a free consultation.<br>Schedule a time to speak to someone. <div class='m-b-1 m-t-2'><button class='btn btn-default' data-dismiss='modal'>Cancel</button> <a href='https://calendly.com/complect' target='_blank' class='btn btn-primary'>Schedule</button></div></div>");
      } else {
        choice.addClass("active");
        cb.prop("checked", true);
      }
    }

    for (var name of ["step1", "step2", "step11"]) {
      nums = [];
      actives = $(".specialist_"+name+" .active");
      for (var act of actives) {
        nums.push($(act).find("input").val());
      }
      if (parent.hasClass("specialist_"+name)) {
        if (name == "step1") { render_step11(); };
        console.log(nums);
        Cookies.set("complect_s_"+name, nums.join("-"), { expires: 7 });
      }
    }

    for (var name of step_names) {
      if ((name != "step1") && (name != "step2") && (name != "step11")) {
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
    step_continue();
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
      if ((parent.hasClass("specialist_step4")) || (parent.hasClass("specialist_step41")) || (parent.hasClass("specialist_step42"))) {
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