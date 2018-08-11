$.onContentReady ($parent) ->
  $('.js-select', $parent).each ->
    $this = $(this)
    return if $this.data('multiselect')
    filtering = $this.data('filter') == 'true' || (!$this.data('filter')? && $this.find('option').length > 10)
    $this.multiselect
      buttonContainer: '<div class="btn-group multiselect-parent" />'
      inheritClass: true
      buttonWidth: '100%'
      enableFiltering: filtering
      enableCaseInsensitiveFiltering: filtering
      enableClickableOptGroups: $this.find('optgroup').length > 0
      nonSelectedText: $this.attr('placeholder')

    # Hack to hide the fake placeholder item
    unless $this.data('show-blank')
      $this.data('multiselect').$ul.find('input[value=""]').parents('li').hide()
