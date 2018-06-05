#= require imagesloaded

update_landing = ->
  #hiw_h = $('#how-it-works-header').find('img').height()
  #$('#header').height window.innerHeight + hiw_h

  #tos_h = $($('#types-of-services > .container')[0]).height()
  #tos_img_h = $('#talent-across-header').height()
  #$('#types-of-services').height(tos_h+tos_img_h/2)

  return

$(window).resize ->
  update_landing()
  return
$(document).ready ->
  update_landing()
  return

$(document).imagesLoaded ->
  update_landing()
  return