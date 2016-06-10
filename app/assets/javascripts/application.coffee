#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap/_loader
#= require microplugin/src/microplugin
#= require sifter/sifter
#= require selectize/dist/js/selectize
#= require_self
#= require_tree ./utilities
#= require_tree ./components

# Custom content ready handler to encompass DOM, ajax (TODO), and turbolinks (TODO) loads
$.onContentReady = (callback) ->
  $ -> callback()
