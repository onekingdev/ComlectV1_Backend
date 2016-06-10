$.onContentReady ($parent) ->
  $('.js-selectize', $parent).each ->
    $this = $(this)
    $this.selectize() unless $this[0].selectize?
