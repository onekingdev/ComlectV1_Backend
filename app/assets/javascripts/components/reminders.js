if (typeof(reactive_reminders) != "undefined") {
  if (reactive_reminders) {
    $(".reactive_reminders input").on("change", function() {
      var tgt_checked = $(this).prop("checked");
      var tgt_reminder_id = parseInt($(this).attr("name").split("_")[1])
      var bsurl = "/business/reminders/";
      if (typeof(reminders_bsurl) != "undefined") {
        bsurl = reminders_bsurl;
      }
      $.ajax({
        type: 'PATCH',
        url: bsurl+tgt_reminder_id+".json?done="+JSON.stringify(tgt_checked),
        success: function(data) {
          //console.log(data);
        }
      });
    });
  }
}