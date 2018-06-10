$('#partnerships-block .entry').click ->
  target = $(this).find("p").html().toLowerCase().replace(/&amp;/ig, "and").replace(/\ /ig, "-")
  window.location = ('' + window.location).replace(/#[A-Za-z0-9_]*$/, '') + '#' + target
  return

#jumpTo = (anchor) ->
#  console.log anchor
#  window.location = ('' + window.location).replace(/#[A-Za-z0-9_]*$/, '') + '#' + anchor
#  return