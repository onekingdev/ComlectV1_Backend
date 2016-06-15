$(document).on 'change', '#project_pricing_type_hourly, #project_pricing_type_fixed', (e) ->
  console.log $('.form-group.project_fixed_budget, .form-group.project_fixed_payment_schedule')
  if $('#project_pricing_type_hourly').prop('checked')
    $('.form-group.project_fixed_budget, .form-group.project_fixed_payment_schedule').addClass('hidden')
    $('.form-group.project_hourly_rate, .form-group.project_hourly_payment_schedule').removeClass('hidden')
  else
    $('.form-group.project_fixed_budget, .form-group.project_fixed_payment_schedule').removeClass('hidden')
    $('.form-group.project_hourly_rate, .form-group.project_hourly_payment_schedule').addClass('hidden')
