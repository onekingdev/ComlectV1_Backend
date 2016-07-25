# Skills tag selection
$.onContentReady ($parent) ->
  $.initializeOnce $parent.find('[id*=skill_selector]'), 'typeahead', ($typeahead) ->
    limit = $typeahead.data('max')
    checkLimit = ->
      disable = Object.keys(selected).length == limit
      $typeahead.prop 'disabled', disable

    $tags = $parent
      .find('.skills-required')
      .on 'click', '.remove', ->
        $this = $(this)
        delete selected[$this.data('skill')]
        $this.parents('li').remove()
        checkLimit()
    selected = {}
    $tags.find('input').each -> selected[$(this).val()] = true
    checkLimit()
    inputName = $typeahead.attr('name').replace('skill_selector', 'skill_names')
    inputTpl = "<li><input type='hidden' name='#{inputName}[]' value='%VALUE%' /><span>%LABEL%</span><span data-skill='%VALUE%' class='remove'>x</span></li>"

    $typeahead.typeahead
      delay: 200
      source: (query, process) ->
        $.getJSON $typeahead.data('source'), { q: query }, (data) ->
          pound = if query[0] == '#' then '' else '#'
          name = "#{pound}#{query}".toLowerCase()
          exists = (i for i in data when i.name is name)[0]
          data = [{ name: name }].concat(data) unless exists
          # Remove items already selected
          data = (i for i in data when selected[i.name] is undefined)
          process data
      updater: (item) ->
        $input = $(inputTpl.replace(/%LABEL%/g, item.name).replace(/%VALUE%/g, item.name))
        selected[item.name] = true
        $tags.append $input
        checkLimit()
        return # Don't display anything on the input

    $typeahead.data 'typeahead-initialized', true
