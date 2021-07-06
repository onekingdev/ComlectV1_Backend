$(document).on 'change', '.js-custom-file-field input', (e) ->
  $this = $(this)
  $this
    .parents('.js-custom-file-field')
    .find('.selected')
      .html($this.val())
