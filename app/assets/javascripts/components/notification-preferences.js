$(document).ready(function() {
  if (typeof(notification_preferences_ajax_enable) != "undefined") {
    $(".reactive_notification_settings input").on("change", function() {
      var tgt_checked = $(this).prop("checked");
      var setting_url = $(this).attr("setting_url");
      $.ajax({
        url: setting_url,
        data: { value: tgt_checked },
        method: 'put'
      });
    })
  }
})