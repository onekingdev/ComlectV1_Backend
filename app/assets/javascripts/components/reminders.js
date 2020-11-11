if (typeof(reactive_reminders) != "undefined") {
  if (reactive_reminders) {
    $("body").on("change", ".reactive_reminders input", function() {
      var _this = this;
      var options = {
        message: "Would you like to add any notes? <br/><br/><textarea class='form-control text optional input-lg' id='reminder_notes_textarea'></textarea><br/>",
        backdrop: true,
        closeButton: true,
        className: 'confirm',
        buttons: {
          cancel: {
            label: 'Cancel',
            className: 'btn-default btn'
          },
          confirm: {
            label: 'Ok',
            className: 'btn-primary btn',
            callback: function() {
              var tgt_checked = $(_this).prop("checked");
              var splitted_name = $(_this).attr("name").split("_");
              var tgt_reminder_id = parseInt(splitted_name[1]);
              var bsurl = "/business/reminders/";
              if (typeof(reminders_bsurl) != "undefined") {
                bsurl = reminders_bsurl;
              }
              var tgt_url = bsurl+tgt_reminder_id+".json?done="+JSON.stringify(tgt_checked);
              if (splitted_name.length == 3) {
                tgt_url += "&oid="+parseInt(splitted_name[2]);
              }
              $.ajax({
                type: 'PATCH',
                url: tgt_url,
                data: { "note": $("#reminder_notes_textarea").val() },
                success: function(data) {
                  console.log(data);
                }
              });
            }
          }
        }
      }
      bootbox.dialog(options);
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

var patch_reminder_datepickers = function(selector) {
  var from_$input = selector.find("input[name='reminder[remind_at]']").pickadate({
    format: $(this).data('format') || 'mmmm d, yyyy',
    formatSubmit: 'yyyy-mm-dd',
    hiddenName: true,
  }),
  from_picker = from_$input.pickadate('picker')

  var to_$input = selector.find("input[name='reminder[end_date]']").pickadate({
    format: $(this).data('format') || 'mmmm d, yyyy',
    formatSubmit: 'yyyy-mm-dd',
    hiddenName: true,
  }),
  to_picker = to_$input.pickadate('picker')

  var end_$input = selector.find("input[name='reminder[end_by]']").pickadate({
    format: $(this).data('format') || 'mmmm d, yyyy',
    formatSubmit: 'yyyy-mm-dd',
    hiddenName: true,
  }),
  end_picker = end_$input.pickadate('picker')

  // Check if there’s a “from” or “to” date to start with.
  if (from_picker.get('value')) {
    to_picker.set('min', from_picker.get('select'))
  }
  // When something is selected, update the “from” and “to” limits.
  from_picker.on('set', function (event) {
    if (event.select) {
      to_picker.set('min', from_picker.get('select'))
      end_picker.set('min', from_picker.get('select'))
    } else if ('clear' in event) {
      to_picker.set('min', false)
      end_picker.set('min', false)
    }
  })

  to_picker.on('set', function (event) {
    if (event.select) {
      from_picker.set('max', to_picker.get('select'))
    } else if ('clear' in event) {
      from_picker.set('max', false)
    }
  })
  end_picker.set('min', from_picker.get('select'))
}

var update_reminder_form = function(selector) {
  switch(selector.find("select[name='reminder[repeats]']").val()) {
    case "Daily":
      selector.find(".reminder_units, .reminder_end_by").show();
      selector.find(".reminder_repeat_every").last().hide();
      selector.find(".reminder_repeat_every").first().show();
      selector.find(".reminder_repeat_on, .reminder_on_type").hide();
      selector.find(".reminder_units").html("day(s)");
      break;
    case "Weekly":
      selector.find(".reminder_repeat_on, .reminder_on_type").hide();
      selector.find(".reminder_repeat_on").last().show();
      selector.find(".reminder_units, .reminder_end_by").show();
      selector.find(".reminder_repeat_every").last().hide();
      selector.find(".reminder_repeat_every").first().show();
      selector.find(".reminder_units").html("week(s)");
      break;
    case "Monthly":
      selector.find(".reminder_on_type, .reminder_units, .reminder_end_by, .reminder_repeat_on").show();
      selector.find(".reminder_repeat_every").last().hide();
      selector.find(".reminder_repeat_every").first().show();
      selector.find(".reminder_units").html("month(s)");
      switch(selector.find("select[name='reminder[on_type]']").val()) {
        case "Day":
          selector.find(".reminder_repeat_on").hide();
          selector.find(".reminder_repeat_on").first().show();
          break;
        default:
          selector.find(".reminder_repeat_on").hide();
          selector.find(".reminder_repeat_on").last().show();
      }
      break;
    case "Yearly":
      selector.find(".reminder_units").html("year(s)");
      selector.find(".reminder_on_type, .reminder_units, .reminder_end_by, .reminder_repeat_on").show();
      selector.find(".reminder_repeat_every").first().hide();
      selector.find(".reminder_repeat_every").last().show();
      switch($("select[name='reminder[on_type]']").val()) {
        case "Day":
          selector.find(".reminder_repeat_on").hide();
          selector.find(".reminder_repeat_on").first().show();
          break;
        default:
          selector.find(".reminder_repeat_on").hide();
          selector.find(".reminder_repeat_on").last().show();
      }
      break;
    case "":
      selector.find(".reminder_repeat_every, .reminder_units, .reminder_repeat_on, .reminder_end_by, .reminder_on_type").hide();
      break;
  }
}