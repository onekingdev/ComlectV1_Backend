$form = $('#new_project_search')
$results = $('.search-results')

doSearch = ->
  $results.addClass 'loading'
  $form.submit()

searchingTimeout = null
delayedSearch = ->
  clearTimeout(searchingTimeout) if searchingTimeout?
  searchingTimeout = setTimeout doSearch, 500

if $form.length > 0
  $form
    .find('input.radio_pills').change(doSearch).end()
    .find('#project_search_sort_by').change(doSearch).end()
    .find('#project_search_location_type').change(delayedSearch).end()
    .find('#project_search_location_range').change(delayedSearch).end()
    .find('#project_search_industry_ids').change(delayedSearch).end()
    .find('#project_search_jurisdiction_ids').change(delayedSearch).end()
    .find('#project_search_experience').change(delayedSearch).end()
    .find('#project_search_regulator').change(doSearch).end()
    .find('#project_search_lat').change(doSearch).end()
    .find('#project_search_skill_selector').on('tags-changed', doSearch).end()
    .find('#project_search_keyword')
      .keydown ->
        $(this).data 'prevVal', $(this).val()
      .keyup ->
        delayedSearch() if $(this).val() != $(this).data('prevVal')
        $(this).data 'prevVal', $(this).val()

  $form.on 'place_changed', doSearch

  $form.on 'reset', ->
    $form
      .find('#project_search_project_type_one-off').prop('checked', true).parent().addClass('active').end().end()
      .find('#project_search_project_type_full-time').prop('checked', false).parent().removeClass('active').end().end()
      .find('#project_search_lat').val('').end()
      .find('#project_search_lng').val('').end()
      .find('#project_search_jurisdiction_ids').multiselect('deselectAll', false).multiselect('updateButtonText').end()
      .find('#project_search_industry_ids').multiselect('deselectAll', false).multiselect('updateButtonText').end()
      .find('#project_search_location_type').multiselect('deselectAll', false).multiselect('updateButtonText').end()
      .find('#project_search_location_type').multiselect('deselectAll', false).multiselect('updateButtonText').end()
      .find('.skills-required').html('')
    $form.find('#project_search_location_range').data('ionRangeSlider').update(from: 0, to: 50)
    $form.find('#project_search_experience').data('ionRangeSlider').update(from: 3, to: 15)
    delayedSearch()

  $('.search-results').on 'click', '.projects-pagination .page', (e) ->
    e.preventDefault()
    $form.find('#project_search_page').val $(this).data('page')
    doSearch()

  $specificLocation = $form.find('.specific-location')
  $form.find('#project_search_location_type').change ->
    if $(this).val() == 'onsite'
      $specificLocation.collapse('show')
    else
      $specificLocation.collapse('hide')

