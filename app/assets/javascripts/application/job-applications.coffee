$('#js-sort-job-applications').on 'change', (e) ->
  window.location.search = "sort_by=" + $(this).val()
