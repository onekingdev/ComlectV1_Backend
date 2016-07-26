$.onContentReady ($parent) ->
  $('.js-datepicker', $parent).each ->
    $picker = $(this)
    return if $picker.data('datepicker-initialized')

    # Limit date-from to max date-to, and viceversa
    if $picker.data('date-from')
      onSet = (context) ->
        select = this.get('select')
        pair = $picker.parents('.js-date-range').find('[data-date-to]').pickadate('picker')
        unless select?
          pair.set({ min: false }, { muted: true })
          return
        pair.set({ min: select }, { muted: true })
    else if $picker.data('date-to')
      onSet = (context) ->
        select = this.get('select')
        pair = $picker.parents('.js-date-range').find('[data-date-from]').pickadate('picker')
        unless select?
          pair.set({ max: false }, { muted: true })
          return
        pair.set({ max: select }, { muted: true })

    $picker.pickadate
      format: $picker.data('format') || 'mmmm d, yyyy'
      formatSubmit: 'yyyy/mm/dd'
      max: $picker.data('max') || undefined
      min: $picker.data('min') || undefined
      selectMonths: if $picker.data('months')? then $picker.data('months') else false
      selectYears: if $picker.data('years')? then $picker.data('years') else false
      hiddenName: true
      onSet: onSet

    $picker.data('datepicker-initialized', true)
