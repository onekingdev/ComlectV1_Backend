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
  $("#modal").modal({backdrop: 'static', keyboard: false});
  $("#modal .modal-body").html(nice_template);
  $("button.close").hide();
  //_Modal.showPlain(nice_template);
}

if (typeof(non_ria_dashboard_fix) != "undefined") {
  $(".fullheight").addClass("fixedheight").removeClass("fullheight").css({"height": "300px"});
}
