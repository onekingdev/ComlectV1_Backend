$('.panel').on 'inserted.bs.popover', '.js-project-extension', ->
#$('.js-project-extension').on 'inserted.bs.popover', (e) -> 
  #console.log $(this).parent.find('.js-project-extension-popover')
  #$wrapper = $('.js-project-extension-popover')
  $wrapper = $(this).parent().find('.js-project-extension-popover')
  console.log $wrapper
  return if $wrapper.data('datepicker-initialized')

  $submit = $wrapper.find('input[type=submit]')
  $picker = $wrapper.find('.new_end_date')
  $picker
    .pickadate
      today: false
      clear: false
      close: false
      format: $picker.data('format') || 'mmmm d, yyyy'
      formatSubmit: 'yyyy-mm-dd'
      min: $picker.data('min')
      hiddenName: true
      onSet: ->
        $submit.removeAttr('disabled').removeClass('disabled')

  $wrapper.data('datepicker-initialized', true)
