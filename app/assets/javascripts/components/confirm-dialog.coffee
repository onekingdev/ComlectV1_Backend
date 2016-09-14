$(document).on 'confirm', '[data-confirm]', (e) ->
  e.stopImmediatePropagation()
  $this = $(this)
  options =
    message: $this.data('confirm')
    backdrop: true
    closeButton: false
    className: 'confirm'
    buttons:
      cancel:
        label: 'Cancel'
        className: 'btn-primary btn-lg'
      confirm:
        label: $this.data('confirm-label') || 'Ok'
        className: 'btn-primary btn-lg'
        callback: ->
          $.rails.handleMethod($this)

  options.title = $this.attr('title') if $this.attr('title') && $this.attr('title').length > 0
  bootbox.dialog options
  return false
