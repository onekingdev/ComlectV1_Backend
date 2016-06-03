$(document).on 'ajax:before', (e) ->
  $(e.target).addClass('loading')

$(document).on 'ajax:complete', (e) ->
  $(e.target).removeClass('loading')
