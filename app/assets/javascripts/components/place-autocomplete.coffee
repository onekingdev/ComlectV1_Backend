$.onContentReady ($parent) ->
  $parent.find('.js-place-autocomplete').each ->
    $this = $(this)
    return if $this.data('autocomplete-initialized')

    $this.on 'keypress', (e) ->
      code = e.keyCode || e.which
      if code == 13
        e.preventDefault()
        return false

    options =
      types: ['geocode']
    autocomplete = new google.maps.places.Autocomplete($this.get(0), options)
    autocomplete.addListener 'place_changed', ->
      place = autocomplete.getPlace()
      for component in place.address_components
        switch component.types[0]
          when "postal_code"
            $this.val component.short_name
          when "locality"
            $($this.data("city")).val component.short_name
          when "administrative_area_level_1"
            $($this.data("state")).val component.long_name
          when "country"
            $($this.data("country")).val component.long_name

    $this.data 'autocomplete-initialized', true
