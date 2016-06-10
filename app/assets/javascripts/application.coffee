#= require jquery
#= require jquery_ujs
#= require bootstrap/_loader
#= require microplugin/src/microplugin
#= require sifter/sifter
#= require selectize/dist/js/selectize
#= require_self
#= require_tree ./utilities
#= require_tree ./components

# Custom content ready handler to encompass DOM and ajax (TODO) loads
$.onContentReady = (callback) ->
  $ -> callback($(document))
