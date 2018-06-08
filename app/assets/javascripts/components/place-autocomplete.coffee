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
      streetNumber = street = zipCode = city = state = country = ''
      for component in place.address_components
        switch component.types[0]
          when "street_number"
            streetNumber = component.short_name
          when "route"
            street = component.long_name
          when "postal_code"
            zipCode = component.short_name
          when "locality"
            city = component.short_name
          when "administrative_area_level_1"
            state = component.short_name
          when "country"
            country = component.short_name

      $($this.data("lat")).val place.geometry.location.lat()
      $($this.data("lng")).val place.geometry.location.lng()
      $($this.data("zipcode")).val zipCode
      $($this.data("city")).val city
      $($this.data("state")).val state
      $($this.data("country")).val country
      switch $this.data('self')
        when "city"
          $this.val city
        when "full"
        else
          $this.val place.name

      $this.trigger 'place_changed'

    $this.data 'autocomplete-initialized', true
