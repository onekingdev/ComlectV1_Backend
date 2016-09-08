$(document).on 'ajax:complete', 'form.new_session', (e, xhr, status) ->
  console.log 'check'
  if xhr.status == 401
    bootbox.alert('Your account is inactive')
