$.onContentReady ($parent) ->
  $("#job_application_message").on 'input', ->
    cnt = 150-parseInt($("#job_application_message").val().length)
    $(".job_application_cnt").html(cnt)
    btn = $(".job_application_message").parent().find("input[type=submit]")
    if cnt < 0
      btn.prop('disabled', true);
    else
      btn.prop('disabled', false);
