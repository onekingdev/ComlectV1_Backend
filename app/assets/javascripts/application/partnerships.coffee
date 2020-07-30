$('#partnerships-block .entry').click ->
  if $(this).hasClass("entry-yellow")
    window.location.href = "mailto:hanh@complect.com?subject=How Can We Partner?"
  else
    target = $(this).find("p").html().replace(/&nbsp;/ig, " ").toLowerCase().replace(/&amp;/ig, "and").replace(/\ /ig, "-")
    window.location = ('' + window.location.pathname).replace(/#[A-Za-z0-9_]*$/, '') + '#' + target
  return
