if (window.location.pathname == "/businesses/new") {
  var step_one = {
    'Banking': ['Investment Banking', 'Retail/Commercial Banking'],
    'Commodities': ['Commodities Pool Operator/Commodities Trading Adviser (exempt and non-exempt)', 'Futures Commission Merchant', 'Retail Foreign Exchange Dealer', 'Introducing Broker', 'Swap Dealer'],
    'Broker Dealer': ['Broker Rep', 'Funding Portal', 'Capital Acquisition Broker', 'Limited Purpose Broker Dealer', 'Broker Dealer', 'Alternative Trading System/Exchange'],
    'Investment Adviser': ['Provide advice to separately managed accounts (e.g. individuals)', 'Provide advice to mutual funds', 'Provide advice to hedge funds', 'Provide advice to private equity funds', 'Provide advice to venture capital funds', 'Provide advice to ERISA accounts', 'Provide advice to Taft-Hartley accounts', 'Provide advice to municipalities or on municipal securities'],
    'Other': [], 
    'Consulting Firm': [], 
    'Recruiter': [], 
    "I don't know": []
  }
  //$(".app_container").html();
  var step_names = ['step1', 'step11', 'step2', 'step3', 'step4', 'step41', 'step42', 'step5'];
  var step_cookies = {};

  $(document).ready(function() {
    for (var name of step_names) {
      step_cookies[name] = Cookies.get('complect_'+name);
    }
    $(".business_step").hide();
    for (var name of step_names) {
      if ((step_cookies[name] == undefined) || (step_cookies[name].length == 0)) {
        $(".business_"+name).show();
        break;
      }
    }
    
    for (var str of Object.keys(step_one)) {
      $(".business_step1 .choices").append("<div class='col-sm-4 m-b-1'><button type='button' class='btn btn-primary btn-block'><input type='checkbox' name='business[step1][]'/>&nbsp;<span>"+str+"</span></button></div>")
    }

    var other = Cookies.get("complect_other");
    if (other != undefined) {
      for (var choice of $(".business_step1 .btn-block")) {
        if ($(choice).text().indexOf("Other") > -1) {
          $(choice).find("span").html("Other ("+other+")");
        }
      }
    }

    for (var name of step_names) {
      if ((step_cookies[name] != undefined) && (name != "step2") && (name != "step11")) {
        for (var num of step_cookies[name].split("-")) {
          var choice = $($(".business_"+name+" .btn-block")[parseInt(num)]);
          choice.addClass("active");
          choice.find("input[type=checkbox]").prop("checked", true);
        }
      }
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
    for (var num of Cookies.get('complect_step1').split("-")) {
      nums.push(parseInt(num));
    }
    $(".business_step11 .choices").html("");
    for (var num of nums) {
      for (var str of step_one[Object.keys(step_one)[num]]) {
        $(".business_step11 .choices").append("<div class='col-sm-12 m-b-1'><button type='button' data-category='"+num+"-"+step_one[Object.keys(step_one)[num]].indexOf(str)+"' class='btn btn-primary btn-block'><input type='checkbox' name='business[step11][]'/>&nbsp;<span>"+str+"</span></button></div>")
      }
    }
    nums = Cookies.get("complect_step11");
    if (nums != undefined) {
      for (var num of nums.split("_")) {
        var active_btn = $(".btn-block[data-category='"+num+"']");
        active_btn.addClass("active");
        active_btn.find("input[type=checkbox]").prop("checked", true);
      }
    }
    step_continue();
  }

  $(".btn_step1").on('click', function() { $(".business_step").hide(); $(".business_step1").show(); });
  $(".btn_step11").on('click', function(e) {
    $(".business_step").hide();
    $(".business_step11").show();
    render_step11();
    e.preventDefault();
    e.stopPropagation();
  });
  $(".btn_step2").on('click', function() { $(".business_step").hide(); $(".business_step2").show(); })
  $(".btn_step3").on('click', function() { $(".business_step").hide(); $(".business_step3").show(); })
  $(".btn_step4").on('click', function() { $(".business_step").hide(); $(".business_step4").show(); })
  $(".btn_step41").on('click', function() { $(".business_step").hide(); $(".business_step41").show(); })
  $(".btn_step42").on('click', function() { $(".business_step").hide(); $(".business_step42").show(); })
  $(".btn_step5").on('click', function() { $(".business_step").hide(); $(".business_step5").show(); })
  $(".btn_step6").on('click', function() { $(".business_step").hide(); $(".business_step6").show(); })

  function step_continue() {
    for (var name of step_names) {
      if (name != "step5") {
        $(".business_"+name).find(".continue").prop("disabled", !($(".business_"+name+" .choices .active").length > 0));
      }
    }
  }

  function toggle_choice(choice) {
    var parent = choice.parent().parent().parent();
    if ((parent.hasClass("business_step4")) || (parent.hasClass("business_step41")) || (parent.hasClass("business_step42"))) {
      var all = parent.find(".btn-block");
      all.removeClass("active");
      for (var al of all) {
        $(al).find("input[type=checkbox]").prop("checked", false);
      }
    }

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
          Cookies.set('complect_other', prompted, { expires: 365 });
        }
        choice.find("span").html("Other ("+prompted+")");
      }
      if (choice.text().indexOf("I don't know") > -1) {
        $(".i_dunno").show();
      }
      choice.addClass("active");
      cb.prop("checked", true);
    }

    var nums = [];
    var actives = $(".business_step1 .active");
    for (var act of actives) {
      nums.push($(".business_step1 .btn-block").index(act));
    }
    if (parent.hasClass("business_step1")) {
      Cookies.set("complect_step1", nums.join("-"), { expires: 365 });
    }

    nums = [];
    actives = $(".business_step11 .active");
    for (var act of actives) {
      nums.push($(act).attr("data-category"));
    }
    if (parent.hasClass("business_step11")) {
      Cookies.set("complect_step11", nums.join("_"), { expires: 365 });
    }

    nums = [];
    actives = $(".business_step2 .active");
    for (var act of actives) {
      nums.push($(act).find("input").val());
    }
    console.log(nums);
    if (parent.hasClass("business_step2")) {
      Cookies.set("complect_step2", nums.join("-"), { expires: 365 });
    }

    for (var name of step_names) {
      if ((name != "step2") && (name != "step11")) {
        nums = [];
        actives = $(".business_"+name+" .active");
        for (var act of actives) {
          nums.push($(".business_"+name+" .btn-block").index(act));
        }
        if (parent.hasClass("business_"+name)) {
          Cookies.set("complect_"+name, nums.join("-"), { expires: 365 });
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