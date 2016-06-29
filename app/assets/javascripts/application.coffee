#= require jquery
#= require jquery_ujs
#= require bootstrap/_loader
#= require bootstrap-multiselect/dist/js/bootstrap-multiselect
#= require pickadate/lib/picker
#= require pickadate/lib/picker.date
#= require pickadate/lib/picker.time
#= require bootbox.js/bootbox
#= require_self
#= require_tree ./utilities
#= require_tree ./components
#= require_tree ./application

# Custom content ready handler to encompass DOM and ajax loads
$.onContentReady = (callback) ->
  $ -> callback($(document))
  # Fire $(document).trigger('newContent', $parent) to trigger this
  $(document).on 'newContent', (_e, $parent) ->
    # Make sure it's jQuery object as sometimes we get in unwrapped
    callback $($parent)
