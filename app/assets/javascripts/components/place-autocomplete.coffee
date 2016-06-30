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
      console.log place.address_components
      street = ''
      streetNumber = ''
      for component in place.address_components
        switch component.types[0]
          when "street_number"
            streetNumber = component.short_name
          when "route"
            street = component.long_name
          when "postal_code"
            $($this.data("zipcode")).val component.short_name
          when "locality"
            $($this.data("city")).val component.short_name
          when "administrative_area_level_1"
            $($this.data("state")).val component.long_name
          when "country"
            $($this.data("country")).val component.long_name
      $this.val [street, streetNumber].join(' ').trim()

    $this.data 'autocomplete-initialized', true
