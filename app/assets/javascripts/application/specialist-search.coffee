$form = $('#new_specialist_search')
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
    .find('#specialist_search_sort_by').change(doSearch).end()
    .find('#specialist_search_industry_ids').change(delayedSearch).end()
    .find('#specialist_search_jurisdiction_ids').change(delayedSearch).end()
    .find('#specialist_search_rating').change(delayedSearch).end()
    .find('#specialist_search_experience').change(delayedSearch).end()
    .find('#specialist_search_regulator').change(doSearch).end()
    .find('#specialist_search_location_range').change(delayedSearch).end()
    .find('#specialist_search_lat').change(doSearch).end()
    .find('#specialist_search_keyword')
      .keydown ->
        $(this).data 'prevVal', $(this).val()
      .keyup ->
        delayedSearch() if $(this).val() != $(this).data('prevVal')
        $(this).data 'prevVal', $(this).val()

  $form.on 'place_changed', doSearch

  $form.on 'reset', ->
    $form
      .find('#specialist_search_lat').val('').end()
      .find('#specialist_search_lng').val('').end()
      .find('#specialist_search_jurisdiction_ids').multiselect('deselectAll', false).multiselect('updateButtonText').end()
      .find('#specialist_search_industry_ids').multiselect('deselectAll', false).multiselect('updateButtonText').end()
    $form.find('#specialist_search_location_range').data('ionRangeSlider').update(from: 0, to: 50)
    $form.find('#specialist_search_experience').data('ionRangeSlider').update(from: 3, to: 15)
    $form.find('#specialist_search_rating').data('ionRangeSlider').update(from: 0, to: 5)
    doSearch()
