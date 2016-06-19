$(document).on 'show.bs.tab', '[data-toggle="tab"]', (e, args) ->
  $this = $(this)
  # We can have multiple triggers for tabs, this code keeps their "active" class in sync
  # When using dropdown menus as triggers, those won't automatically clear their "active" class
  # like the normal tabs, so we clear those manually
  if $this.data('toggle-sync')
    $sync = $("[data-toggle=tab][href=\"#{$this.attr('href')}\"]")
      .parents('ul')
        .find('.active').removeClass('active').end()
      .end()
      .parent().addClass('active').end()

  args ||= {}
  return if !args.force? && (!$this.data('remote-load') || $this.data('remote-loaded') || $sync.hasClass('loading'))

  $tab = $($this.attr('href'))
  $this.addClass('loading')
  $.get $this.data('url'), (html) ->
    $tab.html(html)
    $this
      .removeClass('loading')
      .data('remote-loaded', true)

$.onContentReady ($parent) ->
  $('[data-remote-load][data-toggle="tab"]', $parent).each ->
    $this = $(this)
    $this.trigger('show.bs.tab') if $this.parents('li').hasClass('active')
