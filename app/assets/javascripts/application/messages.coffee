$.onContentReady ($parent, data) ->
  $messages = $parent.find('.messages')
  return if $messages.length == 0
  $messages.scrollTop $messages[0].scrollHeight
