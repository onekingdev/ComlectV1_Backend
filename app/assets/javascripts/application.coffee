#= require jquery
#= require jquery_ujs
#= require bootstrap/_loader
#= require bootstrap-multiselect/dist/js/bootstrap-multiselect
#= require_self
#= require_tree ./utilities
#= require_tree ./components

# Custom content ready handler to encompass DOM and ajax (TODO) loads
$.onContentReady = (callback) ->
  $ -> callback($(document))
