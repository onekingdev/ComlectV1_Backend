$(document).on 'change', '#project_type_one_off, #project_type_full_time', (e) ->
  $this = $(this)
  $this.parents('form').attr('data-project-type', $this.val())

$(document).on 'change', '#project_pricing_type_hourly, #project_pricing_type_fixed', (e) ->
  $this = $(this)
  $this.parents('.project-pricing').attr('data-pricing-type', $this.val())

$(document).on 'change', '#project_location_type', (e) ->
  $this = $(this)
  $this.parents('.project-details').attr('data-location-type', $this.val())

$(document).on 'click', '.flag-link', (e) ->
  e.preventDefault()
  $this = $(this)
  $('.flag-form[data-content="' + $(this).data('content') + '"]').toggle()

do ->
  one_day = 86400000
  parents = ['.project_fixed_payment_schedule', '.project_hourly_payment_schedule']
  selector = '.multiselect-container input[type=radio][value=%value]'
  $(document).on 'change', '#project_starts_on, #project_ends_on', (e) ->
    starts = $("#project_starts_on").pickadate('picker').get('select')
    ends = $("#project_ends_on").pickadate('picker').get('select')
    return unless starts? && ends?

    diff = ends.obj - starts.obj
    # .project_fixed|hourly_payment_schedule
    parentSelector = ".project_#{$('.project-pricing[data-pricing-type]').attr('data-pricing-type')}_payment_schedule"
    for parent in parents
      $(parent).find(selector.replace('%value', 'upon-completion')).parents('li').removeClass('hidden')
      $(parent).find(selector.replace('%value', 'monthly')).parents('li').removeClass('hidden')
    if diff < (one_day * 14)
      for parent in parents
        $(parent).find(selector.replace('%value', 'monthly')).parents('li').addClass('hidden')
    if diff > (one_day * 30)
      for parent in parents
        $(parent).find(selector.replace('%value', 'upon-completion')).parents('li').addClass('hidden')
