setLastChild = ($container) ->
  $container
    .find('.last-child').removeClass('last-child').end()
    .find($container.data('last-child')).addClass('last-child').end()

$('.js-set-last-child').each ->
  $this = $(this)
  $this.on 'cocoon:after-insert', -> setLastChild($this)
  $this.on 'cocoon:after-remove', -> setLastChild($this)
  setLastChild $this

