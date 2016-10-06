$.onContentReady ($parent) ->
  $parent.find('.button-switch').each ->
    $.initializeOnce $(this), 'button-switch', ($button) ->
      options = {}
      if $button[0].hasAttribute('data-remote')
        options.onSwitchChange = (e, state) ->
          $.ajax
            url: $button.data('url')
            data: { value: state }
            method: 'put'
      $button.bootstrapSwitch(options)
