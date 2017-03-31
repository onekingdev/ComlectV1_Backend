$('.delete-photo-button').on 'click', (e) ->
  e.preventDefault()
  $('#specialist_delete_photo').val 1
  $('#specialist_photo').val ""
  $(this).parents("form").submit()
  return

$(".delete-resume-button").on 'click', (e) ->
  e.preventDefault()
  $("#specialist_delete_resume").val 1
  $("#specialist_resume").val ""
  $(this).parents("form").submit()
  return

$(".delete-logo-button").on 'click', (e) ->
  e.preventDefault()
  $("#business_delete_logo").val 1
  $("#business_logo").val ""
  $(this).parents("form").submit()
  return