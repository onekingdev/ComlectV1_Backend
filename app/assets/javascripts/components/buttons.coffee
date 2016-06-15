$(document).on 'click', 'button[data-href]', (e) ->
  e.preventDefault()
  window.location.href = $(this).data('href')
