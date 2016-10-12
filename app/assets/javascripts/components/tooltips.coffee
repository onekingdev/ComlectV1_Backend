$.onContentReady ($parent) ->
  $.initializeOnce $parent.find('[data-toggle=tooltip]'), 'tooltip', ($info) ->
    $info.tooltip()
