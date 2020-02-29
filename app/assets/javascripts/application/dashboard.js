if ((typeof(show_business_personalize) != "undefined") && (show_business_personalize == true)) {
  function personalize_book() {
    $.ajax({
      type: 'GET',
      url: booking_path+".json",
      success: function(data) {
        $(".booking_hide").slideUp(function() {
          $(".booking_hide p").html("This is your dashboard and compliance<br/>command center. Customize it further<br/>by answering some additional questions.<br/><br/>Would you like to do that now?");
          $(".booking_hide img").hide();
          $(".stepbtns").html("<a href='"+personalize_js_url+"' class='btn btn-primary m-r-1'>Proceed</a><button data-dismiss='modal' class='btn btn-default'>Skip</button>");
          $(".personalize_dot_active").removeClass("personalize_dot_active").addClass("personalize_dot_inactive");
          $(".personalize_dot_inactive").last().removeClass("personalize_dot_inactive").addClass("personalize_dot_active");
          $(".booking_hide").slideDown(function() {
            var win = window.open(data.url, '_blank');
            win.focus();
          })
        });
      }
    });
  };
  
  var nice_template = "<div class='modal-body'>"+
                        "<div class='modal-fake text-center modal-wrapper m-x-1 m-y-1 p-t-2 p-x-3 gray' style='max-width: 750px;'>"+
                          "<h3>Welcome to Complect!</h3>"+
                          "<div class='booking_hide'>"+
                            "<p>Let's schedule your on-boarding call.</p>"+
                            "<img src='"+calendar_asset_path+"' width='80px'>"+
                            "<div class='m-b-1 m-t-2 stepbtns'>"+
                              "<button onclick='personalize_book();' class='btn btn-primary m-r-1 '>Book</button>"+
                              "<button class='btn btn-default disabled'>Next</button>"+
                            "</div>"+
                          "</div>"+
                          "<span class='personalize_dot_active m-r-1'></span><span class='personalize_dot_inactive'></span>"
                        "</div>"+
                      "</div>";

  _Modal.showPlain(nice_template);
}

if ((typeof(show_business_tutorial) != "undefined") && (show_business_tutorial == true)) {
  //console.log("showin tutorial");
}

/*if ((typeof(show_business_personalize) != "undefined") && (show_business_personalize == true)) {
  _Modal.showPlain("<div class='modal-body'><div class='modal-fake text-center modal-wrapper m-x-1 m-y-1 p-t-2 p-x-3 gray' style='max-width: 750px;'><h3>Welcome to Complect!</h3><p>Let's schedule your on-boarding call.</p><img src='"+calendar_asset_path+"' width='80px'><div class='m-b-1 m-t-2'><a href='"+personalize_js_url+"' target='_blank' class='btn btn-primary m-r-1'>Book</a><button data-dismiss='modal' class='btn btn-default'>Next</button></div></div>");
}
*/


