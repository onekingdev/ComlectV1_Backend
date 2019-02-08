$('#js-sort-job-applications').on 'change', (e) ->
  queryString = $.queryString()
  queryString.sort_by = $(this).val()
  newQueryString = []
  for query, value of queryString
    newQueryString.push "#{query}=#{value}"
  $anchor = $('#js-application-filters').find('li.active a')
  hash = '#nojump-' + $anchor.attr('href').substr(1)
  location = window.location.pathname + '?' + newQueryString.join('&') + hash
  window.location = location

$(document).on 'change', '#job_application_pricing_type_hourly, #job_application_pricing_type_fixed', (e) ->
  $this = $(this)
  $this.parents('.project-pricing').attr('data-pricing-type', $this.val())