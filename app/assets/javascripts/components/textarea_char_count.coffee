updateCounter = ->
  $textarea = $(this)
  $container = $textarea.parents('[data-remaining-chars]')
  max = $textarea.attr('maxlength')
  $container.attr('data-remaining-chars', max - $textarea.val().length)

$(document).on 'keyup', '[data-remaining-chars] textarea', updateCounter
$(document).on 'keydown', '[data-remaining-chars] textarea', updateCounter
