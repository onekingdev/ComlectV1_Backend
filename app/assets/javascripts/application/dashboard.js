if ((typeof(show_business_personalize) != "undefined") && (show_business_personalize == true)) {
  var personalize_book = function() {
    $(".modal-dialog .close").trigger("click");
    $.ajax({
      type: 'GET',
      url: booking_path+".json",
      success: function(data) {
        var win = window.open(data.url, '_blank');
        win.focus();
      }
    });
  };
  
  var nice_template = '<div class="bootbox-body">'+
                        '<div class="bootbox-heading">Welcome To Complect!<hr></div>'+
                        '<div class="p-x-3 text-center">'+
                          "<p>Let's schedule your on-boarding call.</p>"+
                          "<img src='"+calendar_asset_path+"' width='80px'>"+
                          "<br><button style='width: 140px;' onclick='personalize_book();' class='btn btn-primary m-y-2 clearfix'>Book</button>"+
                        '</div>'+
                      '</div>';
  _Modal.showPlain(nice_template);
}

if ((typeof(show_business_tutorial) != "undefined") && (show_business_tutorial == true)) {
  //console.log("showin tutorial");
}

/*if ((typeof(show_business_personalize) != "undefined") && (show_business_personalize == true)) {
  _Modal.showPlain("<div class='modal-body'><div class='modal-fake text-center modal-wrapper m-x-1 m-y-1 p-t-2 p-x-3 gray' style='max-width: 750px;'><h3>Welcome to Complect!</h3><p>Let's schedule your on-boarding call.</p><img src='"+calendar_asset_path+"' width='80px'><div class='m-b-1 m-t-2'><a href='"+personalize_js_url+"' target='_blank' class='btn btn-primary m-r-1'>Book</a><button data-dismiss='modal' class='btn btn-default'>Next</button></div></div>");
}
*/


