$.onContentReady ($parent) ->
  $('.js-select', $parent).each ->
    $this = $(this)
    return if $this.data('multiselect')
    filtering = if $this.find('option').length > 10 then true else false
    $this.multiselect
      buttonContainer: '<div class="btn-group multiselect-parent" />'
      inheritClass: true
      buttonWidth: '100%'
      enableFiltering: filtering
      enableCaseInsensitiveFiltering: filtering
      enableClickableOptGroups: $this.find('optgroup').length > 0
