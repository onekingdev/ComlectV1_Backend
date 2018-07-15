$.onContentReady ($parent, data) ->
  $messages = if $parent.hasClass('message-thread') then $parent.find('.messages') else $parent.find('.message-thread .messages')
  return if $messages.data('initMessagePolling')

  $('.upload-button').on 'click', ->
    $('.hidden-upload').find('input[type=file]').trigger 'click'
    return
  
  if $messages.length > 0
    $messages = $messages.add $(window)

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
              console.log new_data
              $messages.append new_data
              groupMessagesByDay()
              scrollLast()
      , 5000
      $messages.data 'initMessagePolling', true

    return if $messages.length == 0 || $messages.data('init-scrolled')

    mobile_height = Math.max document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight
    $(window).scrollTop mobile_height

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
        scrollheight_A = $messages[0].scrollHeight
        $messages.prepend data
        groupMessagesByDay() # order is very important otherwise updated scrollTop will set incorrect position
        scrollheight_B = $messages[0].scrollHeight
        $messages.scrollTop $messages.scrollTop() + (scrollheight_B - scrollheight_A)

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
        ratio = Math.max(($messages.scrollTop() / $messages[0].scrollHeight), ($(window).scrollTop() / mobile_height))
        # ratio < previousRatio : Do nothing when scrolling down
        loadMessages() if ratio < previousRatio && ratio < 0.25
        previousRatio = ratio
      , 500

    $('#project-messages').on 'keypress', '.message_message', (e) ->
      if (window.event.keyCode == 13 && $('#send_on_enter').prop('checked'))
          $('.message-form input[type="submit"]').click()
          return false

    adjustMessagesHeight = ->
      if window.innerWidth > 766
        computedHeight = window.innerHeight - ($('.business-profile')[0].offsetTop) - 95
        if $('#new_message').height() != null
          computedHeight -= $('#new_message').height()
          if window.innerHeight < 550
            computedHeight = 250
        $('.messages').css height: computedHeight
      else
        $('.messages').css height: 'auto'
      return

    $(document).ready -> 
      adjustMessagesHeight()
      $messages
        .scrollTop $messages.prop("scrollHeight")
        .data 'init-scrolled', true
    $(window).resize adjustMessagesHeight

    $(document).on 'newContent', (e) ->
      groupMessagesByDay()
      scrollLast()

    scrollLast = ->
      $messages.animate({ scrollTop: $messages.prop("scrollHeight")}, 500)
      if window.innerWidth < 766
        $(window).scrollTop mobile_height
