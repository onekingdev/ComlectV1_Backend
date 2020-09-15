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

    function update_tasks_width() {
      var full_width = $(".calendar_days").width();
      $(".task_middle").each(function() {
        $(this).width(parseInt($(this).attr("data-vduration"))*(full_width/7.0)-8);
      });
    }

    $(document).ready(function() {
      update_tasks_width();
    });

    $(window).on('resize', function() {
      this.update_tasks_width();
    })

    $("#tasks_today_btn").on("click", function() {
      $("#tasks_week").hide();
      $("#tasks_today").show();
      $("#tasks_today_btn").addClass("active");
      $("#tasks_week_btn").removeClass("active");
      fullheight_all();
    });

    $("#tasks_week_btn").on("click", function() {
      $("#tasks_today").hide();
      $("#tasks_week").show();
      $("#tasks_today_btn").removeClass("active");
      $("#tasks_week_btn").addClass("active");
      fullheight_all();
    });

    $("#tasks_week").hide();
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