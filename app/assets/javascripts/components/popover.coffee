$.onContentReady ($parent) ->
  $parent.find('[data-toggle=popover]').popover()

$(document).on 'click', '[data-dismiss=popover]', (e) ->
  e.preventDefault()
  $(this).parents('.popover').data('bs.popover').$element.click()
