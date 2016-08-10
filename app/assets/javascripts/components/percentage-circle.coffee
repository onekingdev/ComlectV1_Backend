$.onContentReady ($parent) ->
  $.initializeOnce $parent.find('.percentage-circle'), 'percentage-circle', ($circle) ->
    $circle.percircle()
