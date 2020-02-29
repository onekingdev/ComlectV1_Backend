if (typeof(reactive_reminders) != "undefined") {
  if (reactive_reminders) {
    $("body").on("change", ".reactive_reminders input", function() {
      var tgt_checked = $(this).prop("checked");
      var splitted_name = $(this).attr("name").split("_");
      var tgt_reminder_id = parseInt(splitted_name[splitted_name.length-1]);
      var bsurl = "/business/reminders/";
      if (typeof(reminders_bsurl) != "undefined") {
        bsurl = reminders_bsurl;
      }
      $.ajax({
        type: 'PATCH',
        url: bsurl+tgt_reminder_id+".json?done="+JSON.stringify(tgt_checked),
        success: function(data) {
          console.log(data);
        }
      });
    });
  }
}

if (typeof(show_reminders_at_date) != "undefined") {
  $(document).ready(function() {
    $("#footer").append("<a href='"+show_reminders_at_date+"' data-toggle='modal' data-target='#modal' data-remote='true' id='reminder_popup_pixel'>&nbsp;</a>")
    $("#reminder_popup_pixel").trigger("click");

    //console.log(show_reminders_at_date);
    //$("#modal").modal('show').load(show_reminders_at_date);
  });
}