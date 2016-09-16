$.onContentReady ($parent) ->
  $('.collapse[data-toggle-in]', $parent).each ->
    $this = $(this)
    return if $this.data('toggle-initialized')?
    $($this.data('toggle-in')).on 'change', ->
      $this.collapse('show') if $(this).prop('checked')
    $($this.data('toggle-out')).on 'change', ->
      $this.collapse('hide') if $(this).prop('checked')
    $this.data 'toggle-initialized', true

$(document).on 'show.bs.collapse', (e) ->
  $list = $(e.target).parents('ul')
  if $list.hasClass('collapse-others')
    $list
      .find('[data-toggle=collapse]').addClass('collapsed').end()
      .find('.collapse').removeClass('in')
