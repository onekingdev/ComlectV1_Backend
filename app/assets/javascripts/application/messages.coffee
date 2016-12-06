$.onContentReady ($parent, data) ->
  $messages = if $parent.hasClass('message-thread') then $parent.find('.messages') else $parent.find('.message-thread .messages')

  group_messages_by_day = ->
    $message_days = $('.messages-day').map -> $(this).attr('class').split(' ')[1]
    $.uniqueSort($message_days).each (_, message_day) ->
      $(".#{message_day}:first").show()
      $(".#{message_day}:not(:first)").hide()

  group_messages_by_day()

  if $messages.length != 0 && $('.messages').is(':visible') && $messages.data('active') == 'true'
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
    prevScrollHeight = $messages[0].scrollHeight
    prevScrollTop = $messages.scrollTop()
    params = $messages.data('params') || {}
    params.page = page
    request = $.get $messages.data('url'), params, (data) ->
      $messages.attr 'data-page', page
      $messages.prepend data
      $messages.scrollTop $messages[0].scrollHeight - prevScrollHeight + prevScrollTop
      group_messages_by_day()

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

  if $messages.data('active') == 'true'
    $messages.on 'scroll', (e) ->
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
