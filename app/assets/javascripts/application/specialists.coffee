# disable Enter for form submission
$('#new_specialist').on 'keyup keypress', (e) ->
  keyCode = e.keyCode || e.which
  if keyCode == 13
    e.preventDefault()
    return false

$ ->
  $('.specialist_current input[type=checkbox]:checked').each (ele) ->
    $(this).trigger('change')

$(document).on 'change', '.specialist_current input[type=checkbox]', (e) ->
  $to = $(this).parents('.nested-fields').find('.specialist_work_experiences_to')
  if $(this).prop('checked')
    $to.find('input').val('').end().hide()
  else
    $to.show()
