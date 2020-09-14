var patch_js_select = function($parent) {
  $('.js-select', $parent).each(function() {
    var $this, filtering;
    $this = $(this);
    if ($this.data('multiselect')) {
      return;
    }
    filtering = $this.data('filter') === 'true' || (($this.data('filter') == null) && $this.find('option').length > 10);
    $this.multiselect({
      buttonContainer: '<div class="btn-group multiselect-parent" />',
      inheritClass: true,
      buttonWidth: '100%',
      enableFiltering: filtering,
      enableCaseInsensitiveFiltering: filtering,
      enableClickableOptGroups: $this.find('optgroup').length > 0,
      nonSelectedText: $this.attr('placeholder')
    });
    if (typeof ($this.attr('multiple')) === "undefined") {
      $this.parent().find('.multiselect-selected-text').html($this.attr('placeholder'));
    }
    if (!$this.data('show-blank')) {
      return $this.data('multiselect').$ul.find('input[value=""]').parents('li').hide();
    }
  });
}

$.onContentReady(function($parent) {
  patch_js_select($parent);
});