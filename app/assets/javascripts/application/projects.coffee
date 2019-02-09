$(document).on 'change', '#project_type_rfp, #project_type_one_off, #project_type_full_time', (e) ->
  $this = $(this)
  $this.parents('form').attr('data-project-type', $this.val())

$(document).on 'change', '#project_duration_type_asap, #project_duration_type_custom', (e) ->
  $this = $(this)
  $this.parents('.project-duration').attr('data-duration-type', $this.val())

$(document).on 'change', '#project_pricing_type_hourly, #project_pricing_type_fixed', (e) ->
  $this = $(this)
  $this.parents('.project-pricing').attr('data-pricing-type', $this.val())

$(document).on 'change', '#project_location_type', (e) ->
  $this = $(this)
  $this.parents('.project-details').attr('data-location-type', $this.val())

$(document).on 'click', '.flag-link', (e) ->
  e.preventDefault()
  $this = $(this)
  content = $('.flag-form[data-content="' + $(this).data('content') + '"]').html()
  _Modal.showPlain(content)

$ ->
  hash = window.location.hash
  hash and $('ul.nav a[href="' + hash + '"]').tab('show')
  $('.nav-pills a').click (e) ->
    $(this).tab 'show'
    scrollmem = $('body').scrollTop() or $('html').scrollTop()
    window.location.hash = @hash
    $('html,body').scrollTop scrollmem
    return
  return

do ->
  one_day = 86400000
  selects = ['#project_fixed_payment_schedule', '#project_hourly_payment_schedule']
  parents = ['.project_fixed_payment_schedule', '.project_hourly_payment_schedule']
  selector = '.multiselect-container input[type=radio][value=%value]'

  $(document).on 'change', '#project_estimated_days', (e) ->
    days = e.currentTarget.value

    for parent in parents
      $(parent).find(selector.replace('%value', 'upon_completion')).parents('li').removeClass('hidden')
      $(parent).find(selector.replace('%value', 'monthly')).parents('li').removeClass('hidden')
      $(parent).find(selector.replace('%value', 'bi_weekly')).parents('li').removeClass('hidden')

    if days < 15
      for select in selects
        $(select).val('').multiselect('refresh')

      for parent in parents
        $(parent).find(selector.replace('%value', 'monthly')).parents('li').addClass('hidden')
        $(parent).find(selector.replace('%value', 'bi_weekly')).parents('li').addClass('hidden')

    if days < 30
      for select in selects
        $(select).val('').multiselect('refresh')

      for parent in parents
        $(parent).find(selector.replace('%value', 'monthly')).parents('li').addClass('hidden')

  $(document).on 'change', '#project_starts_on, #project_ends_on', (e) ->
    starts = $("#project_starts_on").pickadate('picker').get('select')
    ends = $("#project_ends_on").pickadate('picker').get('select')
    return unless starts? && ends?

    diff = ends.obj - starts.obj
    parentSelector = ".project_#{$('.project-pricing[data-pricing-type]').attr('data-pricing-type')}_payment_schedule"

    for parent in parents
      $(parent).find(selector.replace('%value', 'upon_completion')).parents('li').removeClass('hidden')
      $(parent).find(selector.replace('%value', 'monthly')).parents('li').removeClass('hidden')
      $(parent).find(selector.replace('%value', 'bi_weekly')).parents('li').removeClass('hidden')

    if diff < (one_day * 15)
      for select in selects
        $(select).val('').multiselect('refresh')

      for parent in parents
        $(parent).find(selector.replace('%value', 'monthly')).parents('li').addClass('hidden')
        $(parent).find(selector.replace('%value', 'bi_weekly')).parents('li').addClass('hidden')

    if diff < (one_day * 30)
      for select in selects
        $(select).val('').multiselect('refresh')

      for parent in parents
        $(parent).find(selector.replace('%value', 'monthly')).parents('li').addClass('hidden')

do ->
  one_day = 86400000
  selects = ['#job_application_fixed_payment_schedule', '#job_application_hourly_payment_schedule']
  parents = ['.job_application_fixed_payment_schedule', '.job_application_hourly_payment_schedule']
  selector = '.multiselect-container input[type=radio][value=%value]'

  $(document).on 'change', '#job_application_starts_on, #job_application_ends_on', (e) ->
    starts = $("#job_application_starts_on").pickadate('picker').get('select')
    ends = $("#job_application_ends_on").pickadate('picker').get('select')
    return unless starts? && ends?

    diff = ends.obj - starts.obj
    parentSelector = ".job_application_#{$('.job-application-pricing[data-pricing-type]').attr('data-pricing-type')}_payment_schedule"

    for parent in parents
      $(parent).find(selector.replace('%value', 'upon_completion')).parents('li').removeClass('hidden')
      $(parent).find(selector.replace('%value', 'monthly')).parents('li').removeClass('hidden')
      $(parent).find(selector.replace('%value', 'bi_weekly')).parents('li').removeClass('hidden')

    if diff < (one_day * 15)
      for select in selects
        $(select).val('').multiselect('refresh')

      for parent in parents
        $(parent).find(selector.replace('%value', 'monthly')).parents('li').addClass('hidden')
        $(parent).find(selector.replace('%value', 'bi_weekly')).parents('li').addClass('hidden')

    if diff < (one_day * 30)
      for select in selects
        $(select).val('').multiselect('refresh')

      for parent in parents
        $(parent).find(selector.replace('%value', 'monthly')).parents('li').addClass('hidden')
