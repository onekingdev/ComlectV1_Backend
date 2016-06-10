$.onContentReady ->
  $('.collapse[data-toggle-in]').each ->
    $this = $(this)
    return if $this.data('toggle-initialized')?
    $($this.data('toggle-in')).on 'change', ->
      $this.collapse('show') if $(this).prop('checked')
    $($this.data('toggle-out')).on 'change', ->
      $this.collapse('hide') if $(this).prop('checked')
    $this.data 'toggle-initialized', true
