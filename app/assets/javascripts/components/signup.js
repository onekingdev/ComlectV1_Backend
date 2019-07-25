if ((window.location.pathname == "/businesses/new") || ($("body").hasClass("businesses") && $("body").hasClass("create"))) {
  var step_one = {
    'Banking': ['Investment Banking', 'Retail/Commercial Banking'],
    'Commodities': ['Commodities Pool Operator/Commodities Trading Adviser (exempt and non-exempt)', 'Futures Commission Merchant', 'Retail Foreign Exchange Dealer', 'Introducing Broker', 'Swap Dealer'],
    'Broker Dealer': ['Broker Rep', 'Funding Portal', 'Capital Acquisition Broker', 'Limited Purpose Broker Dealer', 'Broker Dealer', 'Alternative Trading System/Exchange'],
    'Investment Adviser': ['Provide advice to separately managed accounts (e.g. individuals)', 'Provide advice to mutual funds', 'Provide advice to hedge funds', 'Provide advice to private equity funds', 'Provide advice to venture capital funds', 'Provide advice to ERISA accounts', 'Provide advice to Taft-Hartley accounts', 'Provide advice to municipalities or on municipal securities']
  }
  //$(".app_container").html();
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
    //for (var str of Object.keys(step_one)) {
    //  $(".business_step1 .choices").append("<div class='col-sm-4 m-b-1'><button type='button' class='btn btn-primary btn-block'><input type='checkbox' name='business[step1][]'/>&nbsp;<span>"+str+"</span></button></div>")
    //}

    var other = Cookies.get("complect_other");
    if (other != undefined) {
      for (var choice of $(".business_step1 .btn-block")) {
        if ($(choice).text().indexOf("Other") > -1) {
          $(choice).find("span").html("Other ("+other+")");
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

    if (step_cookies["step1"] != undefined) {
      for (var num of step_cookies["step1"].split("-")) {
        var choice = $(".business_step1 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
      render_step11();
    }

    if (step_cookies["step2"] != undefined) {
      for (var num of step_cookies["step2"].split("-")) {
        var choice = $(".business_step2 .btn-block input[value="+num+"]").parent();
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_continue();
  });

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
    for (var i = 2; i < step_names.length; i++) {
      var name = step_names[i];
      if ((step_cookies[name] == undefined) || (step_cookies[name].length == 0)) {
        $(".business_"+step_names[i-1]).show();
        break;
      }
    }
  });
  $(".btn_step0").on('click', function() { $(".business_step").hide(); $(".business_step0").show(); window.scrollTo(0,0); });
  $(".btn_step1").on('click', function() { $(".business_step").hide(); $(".business_step1").show(); window.scrollTo(0,0); });
  $(".btn_step11").on('click', function(e) {
    $(".business_step").hide();
    $(".business_step11").show();
    render_step11();
    e.preventDefault();
    e.stopPropagation();
    window.scrollTo(0,0);
  });

  $(".btn_step2").on('click', function() { $(".business_step").hide(); $(".business_step2").show(); window.scrollTo(0,0); });
  $(".btn_step3").on('click', function() { $(".business_step").hide(); $(".business_step3").show(); window.scrollTo(0,0); });
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
            $("#business_user_attributes_password").focus();
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
      if (choice.text().indexOf("I don't know") > -1) {
        $(".i_dunno").hide();
      }
    } else {
      if (choice.text().indexOf("Other") > -1) {
        var prompted = prompt("Please specify other");
        if ((prompted == undefined) || (prompted.length < 1)) {
          return false;
        } else {
          Cookies.set('complect_other', prompted, { expires: 7 });
        }
        choice.find("span").html("Other ("+prompted+")");
      }
      if (choice.text().indexOf("I don't know") > -1) {
        $(".i_dunno").show();
      }
      choice.addClass("active");
      cb.prop("checked", true);
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