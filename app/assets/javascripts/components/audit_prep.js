$(document).ready(function() {
  if (typeof(_audit_request_id) != "undefined") {
    $("html, body").stop().animate({scrollTop:$("#_audit_request_"+_audit_request_id).position().top-100}, 500, 'swing');
  }

  $(".audit_requests.index, .audit_requests.show").on("click", ".btn-purchase", function() {
    $.ajax({
      type: 'POST',
      url: _audit_requests_url,
      data: { id: $(this).attr("data-identifier") },
      success: function(data) {
        window.location = data.url;
      }
    });
  });

  $(".audit_requests.index, .audit_requests.show").on("click", ".btn-customize", function() {
    window.location = _audit_requests_url+"/new?id="+$(this).attr("data-identifier");
  });

  if (typeof(patch_audit_prep) != "undefined") {
    $(".audit_comments_form textarea").on("keyup", function() {
      if ($(this).val().length > 0) {
        $(this).parent().find(".fake_checkbox").addClass("checked");
      } else {
        $(this).parent().find(".fake_checkbox").removeClass("checked");
      }
    });
    $(".audit_comments_form .savebtn").on("click", function(e) {
      e.preventDefault();
      $.ajax({
        url: $("form.audit_comments_form").attr('action'),
        method: "PUT",
        data: $("form.audit_comments_form").serialize()
      }).done(function(d) {
        coolnotify("Saved", "success");
      }).fail(function(d) {
        coolnotify("Error", "danger");
      });
    });
  }
})