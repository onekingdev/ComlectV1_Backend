$.onContentReady ($parent) ->
  $.initializeOnce $parent.find('.js-range-slider'), 'range-slider', ($slider) ->
    $slider.ionRangeSlider
      onChange: (data) ->
        data.input.val "#{data.from};#{data.to}"
