$(document).on 'change', '#project_pricing_type_hourly, #project_pricing_type_fixed', (e) ->
  if $('#project_pricing_type_hourly').prop('checked')
    $('.form-group.project_fixed_budget, .form-group.project_fixed_payment_schedule').addClass('hidden')
    $('.form-group.project_hourly_rate, .form-group.project_hourly_payment_schedule').removeClass('hidden')
  else
    $('.form-group.project_fixed_budget, .form-group.project_fixed_payment_schedule').removeClass('hidden')
    $('.form-group.project_hourly_rate, .form-group.project_hourly_payment_schedule').addClass('hidden')

$(document).on 'change', '#project_location_type', (e) ->
  $this = $(this)
  if $this.val() == 'remote' || $this.val() == 'remote-travel'
    $this.parents('.project-details').addClass('taller-description')
      .find('.form-group.project_location').removeClass('hidden')
  else
    $this.parents('.project-details').removeClass('taller-description')
      .find('.form-group.project_location').addClass('hidden')
