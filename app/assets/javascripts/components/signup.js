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

  $(document).ready(function() {
    $(".business_step").hide();
    if (Cookies.get('complect_step1') == undefined) {
      $(".business_step1").show();
    } else if (Cookies.get('complect_step11') == undefined) {
      $(".business_step11").show();
      render_step11();
    }
    
    for (var str of Object.keys(step_one)) {
      $(".business_step1 .choices").append("<div class='col-sm-4 m-b-1'><button class='btn btn-primary btn-block'><input type='checkbox'/>&nbsp;<span>"+str+"</span></button></div>")
    }

    var other = Cookies.get("complect_other");
    if (other != undefined) {
      for (var choice of $(".business_step1 .btn-block")) {
        if ($(choice).text().indexOf("Other") > -1) {
          $(choice).find("span").html("Other ("+other+")");
        }
      }
    }

    var step1 = Cookies.get("complect_step1");
    if (step1 != undefined) {
      for (var num of step1.split("-")) {
        var choice = $($(".business_step1 .btn-block")[parseInt(num)]);
        choice.addClass("active");
        choice.find("input[type=checkbox]").prop("checked", true);
        step1_continue();
      }
    }
  });

  function render_step11() {
    var nums = [];
    for (var num of Cookies.get('complect_step1').split("-")) {
      nums.push(parseInt(num));
    }
    console.log(nums);
    $(".business_step11 .choices").html("");
    for (var num of nums) {
      for (var str of step_one[Object.keys(step_one)[num]]) {
        $(".business_step11 .choices").append("<div class='col-sm-12 m-b-1'><button data-category='"+num+"-"+step_one[Object.keys(step_one)[num]].indexOf(str)+"' class='btn btn-primary btn-block'><input type='checkbox'/>&nbsp;<span>"+str+"</span></button></div>")
      }
    }
  }

  $(".btn_step1").on('click', function() {
    $(".business_step11").hide();
    $(".business_step1").show();
  });

  $(".btn_step11").on('click', function() {
    $(".business_step1").hide();
    $(".business_step11").show();
    render_step11();
  });

  function step1_continue() {
    $(".btn_step11").prop("disabled", !($(".business_step1 .choices .active").length > 0));
  }

  function toggle_choice(choice) {
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
    step1_continue();
    var nums = [];
    var actives = $(".business_step1 .active");
    for (var act of actives) {
      nums.push($(".business_step1 .btn-block").index(act));
    }
    console.log(nums);
    Cookies.set("complect_step1", nums.join("-"), { expires: 365 });
  }

  $(".choices").on('click', 'button', function() {
    toggle_choice($(this));
  });

  $(".choices").on('click', "input[type='checkbox']", function(e) {
    e.stopPropagation();
    var checked = $(this).prop("checked");
    if (checked) {
      $(this).parent().removeClass("active");
    } else {
      $(this).parent().addClass("active");
    }
    if (toggle_choice($(this).parent()) == false) {
      $(this).prop("checked", false);
    }
  });
}