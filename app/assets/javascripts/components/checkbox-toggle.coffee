$.onContentReady ($parent) ->
  $.initializeOnce $parent.find('input[type=checkbox][data-toggle-all]'), 'checkbox-toggle', ($selectAll) ->
    selector = "input[name=\"#{$selectAll.data('toggle-all')}\"]:visible"
    $selectAll.click ->
      $(selector)
        .prop 'checked', $selectAll.is(':checked')
        .attr 'checked', if $selectAll.is(':checked') then 'checked' else null
    $(selector)
      .change ->
        all = $("#{selector}:checked").length == $("#{selector}").length
        $selectAll.prop 'checked', all
