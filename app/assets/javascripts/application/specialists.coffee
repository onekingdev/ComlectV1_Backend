$ ->
  $('.specialist_current input[type=checkbox]:checked').each (ele) ->
    $(this).trigger('change')

$(document).on 'change', '.specialist_current input[type=checkbox]', (e) ->
  $to = $(this).parents('.nested-fields').find('.specialist_work_experiences_to')
  if $(this).prop('checked')
    $to.find('input').val('').end().hide()
  else
    $to.show()
