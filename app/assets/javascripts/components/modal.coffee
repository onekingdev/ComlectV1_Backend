class window._ModalClass
  showPlain: (content, options) =>
    options ||= {}
    classes = options.class
    keep = ['modal', 'fade']
    $modal = @modal()
    $.each $modal.attr('class').split(' '), ->
      $modal.removeClass(this) unless keep.indexOf(this)
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
