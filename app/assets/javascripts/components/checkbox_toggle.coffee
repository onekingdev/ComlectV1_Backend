$(document).on 'click', 'input[type=checkbox][data-toggle-all]', (e) ->
  $this = $(this)
  selector = "input[name=\"#{$this.data('toggle-all')}\"]"
  $(selector).prop 'checked', $this.is(':checked')
