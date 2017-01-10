$(document).on 'ajax:complete', 'form.new_session', (e, xhr, status) ->
  if xhr.status == 401
    bootbox.alert('You account has been temporarily suspend. Please contact us to reactivate your account.')
