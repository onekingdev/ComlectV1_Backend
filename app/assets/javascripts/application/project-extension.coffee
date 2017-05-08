$('#js-project-extension').on 'inserted.bs.popover', ->
  $wrapper = $('.js-project-extension-popover')
  return if $wrapper.data('datepicker-initialized')

  $submit = $wrapper.find('input[type=submit]')
  $picker = $wrapper.find('#project_extension_new_end_date')
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
