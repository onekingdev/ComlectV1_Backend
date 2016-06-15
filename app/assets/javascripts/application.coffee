#= require jquery
#= require jquery_ujs
#= require bootstrap/_loader
#= require bootstrap-multiselect/dist/js/bootstrap-multiselect
#= require pickadate/lib/picker
#= require pickadate/lib/picker.date
#= require pickadate/lib/picker.time
#= require_self
#= require_tree ./utilities
#= require_tree ./components
#= require_tree ./application

# Custom content ready handler to encompass DOM and ajax (TODO) loads
$.onContentReady = (callback) ->
  $ -> callback($(document))
