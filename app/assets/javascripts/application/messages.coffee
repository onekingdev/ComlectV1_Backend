$.onContentReady ($parent, data) ->
  $messages = if $parent.hasClass('message-thread') then $parent.find('.messages') else $parent.find('.message-thread .messages')

  groupMessagesByDay = ->
    $messageDays = $('.messages-day').map -> $(this).attr('class').split(' ')[1]
    $.uniqueSort($messageDays).each (_, messageDay) ->
      $(".#{messageDay}:first").show()
      $(".#{messageDay}:not(:first)").hide()

  groupMessagesByDay()

  if $messages.length != 0 && $('.messages').is(':visible') && $messages.data('active')
    setInterval ->
      if $('.messages').is(':visible')
        request = $.get $messages.data('url'), (data) ->
          new_data = $(data).find('[data-message-id]').filter ->
            $(this).data("message-id") > $('[data-message-id]').last().data('message-id')
          if new_data.length > 0
            $messages.append new_data
            $messages.animate({ scrollTop: $messages.prop("scrollHeight")}, 500)
    , 5000

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
    params = $messages.data('params') || {}
    params.page = page
    request = $.get $messages.data('url'), params, (data) ->
      $messages.attr 'data-page', page
      scrolltop_A = $messages.scrollTop()
      scrollheight_A = $messages[0].scrollHeight
      $messages.prepend data
      scrollheight_B = $messages[0].scrollHeight
      $messages.scrollTop scrolltop_A + scrollheight_B - scrollheight_A - 348 # TODO: what is 348
      groupMessagesByDay()

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
    console.log "sc:"+$messages.scrollTop()
    console.log "sh :"+$messages[0].scrollHeight
    clearTimeout(scrollTick) if scrollTick?
    return if loadingMessages
    scrollTick = setTimeout ->
      ratio = $messages.scrollTop() / $messages[0].scrollHeight
      # ratio < previousRatio : Do nothing when scrolling down
      loadMessages() if ratio < previousRatio && ratio < 0.25
      previousRatio = ratio
    , 500

  $('.message_message').on 'keypress', (e) ->
    if (window.event.keyCode == 13 && $('#send_on_enter').prop('checked'))
        $('.message-form input[type="submit"]').click()
        return false
