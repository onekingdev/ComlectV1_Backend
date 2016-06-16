$(document).on 'change', '#project_type_one-off, #project_type_full-time', (e) ->
  $this = $(this)
  $this.parents('form').attr('data-project-type', $this.val())

$(document).on 'change', '#project_pricing_type_hourly, #project_pricing_type_fixed', (e) ->
  $this = $(this)
  $this.parents('.project-pricing').attr('data-pricing-type', $this.val())

$(document).on 'change', '#project_location_type', (e) ->
  $this = $(this)
  $this.parents('.project-details').attr('data-location-type', $this.val())
