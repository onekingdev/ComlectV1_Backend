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
  $sync.addClass('loading')
  $.get $this.data('url'), (html) ->
    $tab.html(html)
    $(document).trigger 'newContent', $tab
    $sync.removeClass('loading')
    $this
      .removeClass('loading')
      .data('remote-loaded', !$tab.data('always-reload'))

$.onContentReady ($parent) ->
  $('[data-remote-load][data-toggle="tab"]', $parent).each ->
    $this = $(this)
    $this.trigger('show.bs.tab') if $this.parents('li').hasClass('active')
