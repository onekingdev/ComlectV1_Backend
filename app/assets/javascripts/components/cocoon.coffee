$(document).on 'cocoon:after-insert', (_e, ele) ->
  $(document).trigger('newContent', $(ele))
