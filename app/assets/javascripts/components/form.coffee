$(document).on 'change', 'input[data-autosubmit]', (e) ->
  $(this).parents('form').submit()
