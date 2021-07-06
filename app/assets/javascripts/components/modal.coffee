class window._ModalClass
  showPlain: (content, options) =>
    options ||= {}
    classes = options.class
    keep = ['modal', 'fade', 'in']
    $modal = @modal()
    $.each $modal.attr('class').split(' '), ->
      cssClass = this.toString()
      $modal.removeClass(cssClass) if keep.indexOf(cssClass) == -1
    $modal
      .addClass("plain #{classes}")
      .find('.modal-body').html(content).end()
      .modal('show')
      .modal('handleUpdate')

  modal: =>
    $modal = $('#modal')
    return $modal if $modal.data('initialized')
    $modal
      .modal
        show: false
      .data 'initialized', true

window._Modal = new _ModalClass()
