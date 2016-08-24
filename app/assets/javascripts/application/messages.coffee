$.onContentReady ($parent, data) ->
  $messages = if $parent.hasClass('message-thread') then $parent.find('.messages') else $parent.find('.message-thread .messages')
  return if $messages.length == 0 || $messages.data('init-scrolled')
  $messages
    .scrollTop $messages[0].scrollHeight
    .data 'init-scrolled'

  return unless $messages.data('url')?

  scrollTick = null
  previousRatio = 1
  loadingMessages = false
  loadMessages = ->
    loadingMessages = true
    $messages.addClass 'loading'

    page = parseInt($messages.attr('data-page') || 1) + 1
    prevScrollHeight = $messages[0].scrollHeight
    prevScrollTop = $messages.scrollTop()
    params = $messages.data('params') || {}
    params.page = page
    request = $.get $messages.data('url'), params, (data) ->
      $messages.attr 'data-page', page
      $messages.prepend data
      $messages.scrollTop $messages[0].scrollHeight - prevScrollHeight + prevScrollTop

    request
      .fail ->
        bootbox.alert
          message: "<h2>Error</h2><p>Messages could not be retrieved, please try again later.</p>"
          backdrop: true
          closeButton: false
          className: 'alert'
      .always ->
        $messages.removeClass 'loading'
        loadingMessages = false

  $messages.on 'scroll', (e) ->
    clearTimeout(scrollTick) if scrollTick?
    return if loadingMessages
    scrollTick = setTimeout ->
      ratio = $messages.scrollTop() / $messages[0].scrollHeight
      # ratio < previousRatio : Do nothing when scrolling down
      loadMessages() if ratio < previousRatio && ratio < 0.25
      previousRatio = ratio
    , 500

