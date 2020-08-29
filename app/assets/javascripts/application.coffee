#= require jquery
#= require jquery_ujs
#= require jquery-ui/widget
#= require jquery-ui/sortable
#= require jquery.slick
#= require jquery.mousewheel
#= require cocoon
#= require bootstrap/_loader
#= require bootstrap-multiselect/dist/js/bootstrap-multiselect
#= require pickadate/lib/picker
#= require pickadate/lib/picker.date
#= require pickadate/lib/picker.time
#= require bootbox.js/bootbox
#= require bootstrap3-typeahead/bootstrap3-typeahead
#= require jquery-mask-plugin/dist/jquery.mask
#= require ion.rangeSlider/js/ion.rangeSlider
#= require percircle/src/js/percircle
#= require accounting.js/accounting
#= require parallax.js/parallax
#= require bootstrap-switch/dist/js/bootstrap-switch
#= require utilities/content-initializer
#= require_self
#= require_tree ./utilities
#= require_tree ./components
#= require_tree ./application
#= require js.cookie
#= require d3
#= require c3

$ ->

  # if document.cookie.includes('accept_cookies')
  #   $('#cookie-modal').remove()

  $('#no-user-cookie-agree').on 'click', () ->
    document.cookie = 'accept_cookies=true'
    $('#cookie-modal').remove()

  $('#no-user-cookie-decline').on 'click', () ->
    $('#cookie-modal').remove()
