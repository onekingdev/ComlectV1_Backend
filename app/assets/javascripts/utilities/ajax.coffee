$(document).on 'ajax:before', (e) ->
  $(e.target).addClass('loading')

$(document).on 'ajax:complete', (e) ->
  $(e.target).removeClass('loading')

$(document).on 'click', '.remote-submit', (e) ->
  form = $(this).closest("form")
  $.ajax
    type: 'POST'
    url: form.attr("action")
    data: form.serialize()
    success: (data) ->
      _Modal.showPlain(data)
