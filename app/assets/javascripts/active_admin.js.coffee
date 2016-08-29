#= require active_admin/base
#= require best_in_place
#= require jquery.purr
#= require best_in_place.purr
#= require webui-popover/src/jquery.webui-popover.js

$ ->
  $('.best_in_place').best_in_place()
  $('[data-title]').webuiPopover()
