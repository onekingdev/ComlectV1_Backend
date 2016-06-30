$.onContentReady ($parent) ->
  $parent.find('[data-masked]').each ->
    $.initializeOnce $(this), 'input-mask', ($this) ->
      $this.mask $this.data('masked'), reverse: $this.data('reverse')
