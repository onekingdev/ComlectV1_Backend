$('#partnerships-block .entry').click ->
  target = $(this).find("p").html().replace(/&nbsp;/ig, " ").toLowerCase().replace(/&amp;/ig, "and").replace(/\ /ig, "-")
  main_path = ''
  if window.location.pathname.indexOf('marketplace') < 0
    window.location = ("/marketplace").replace(/#[A-Za-z0-9_]*$/, '') + '#' + target
  else
    window.location = ('' + window.location.pathname).replace(/#[A-Za-z0-9_]*$/, '') + '#' + target
  return
