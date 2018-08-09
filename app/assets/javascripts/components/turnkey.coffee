window.fix_turnkeys = -> 
  max_height = 0
  $('.turnkey-entry').each ->
    $(this).find("form").height "auto"
  $('.turnkey-entry > form').each ->
    if $(this).height() > max_height
      max_height = $(this).height()
  $('.turnkey-entry').each ->
    $(this).find("form").height max_height

$.onContentReady ($parent) ->
  window.fix_turnkeys()

$(window).resize ->
  window.fix_turnkeys()
