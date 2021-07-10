$ ->
  $projectLocationType = $('select#project_location_type')
  $projectLocationWrapper = $('#project_location_input')

  handleProjectLocationChange = ->
    if $projectLocationType.val() == 'remote'
      $projectLocationWrapper.hide()
    else
      $projectLocationWrapper.show()

  $projectLocationType.change handleProjectLocationChange
  handleProjectLocationChange()
