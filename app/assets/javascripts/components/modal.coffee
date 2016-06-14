class window._ModalClass
  showPlain: (content, options) =>
    options ||= {}
    classes = options.class
    @modal()
      .removeAttr('class')
      .addClass('modal fade plain ' + classes)
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
