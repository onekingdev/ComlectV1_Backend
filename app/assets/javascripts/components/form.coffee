$(document).on 'change', 'input[data-autosubmit]', (e) ->
  $(this).parents('form').submit()

$(document).ready ->
  $('#education-histories').find('.remove_fields').first().removeClass('remove_fields').click (e) ->
      e.preventDefault()

  $('#work-experiences').find('.remove_fields').first().removeClass('remove_fields').click (e) ->
      e.preventDefault()