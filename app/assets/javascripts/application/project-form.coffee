# disable Enter for form submission
$('#new_project').on 'keyup keypress', (e) ->
  keyCode = e.keyCode || e.which
  if keyCode == 13
    e.preventDefault()
    return false

filter_project_form = (val) ->
  if val == 'rfp'
    $('.project-details .project_title').prependTo $($('.project-details .col-sm-8')[0])
    $(".project_jurisdiction_ids").appendTo $($('.project-details .col-sm-4')[0])
  else
    $('.project-details .project_title').prependTo $($('.project-details .col-sm-4')[0])
    $(".project_jurisdiction_ids").prependTo $($('.project-details .col-sm-4')[1])
  return

$(document).ready ->
  project_type = $('.project_type .active input')
  if (project_type.length > 0)
    project_type_val = project_type.val()
    filter_project_form(project_type_val)
  $($(".project_type .btn-default")[0]).attr("title", "Have a problem, but don't know exactly what the solution might look like? Solicit an RFP from our specialists and let them tell you.")
  return

$(document).on 'change', '#project_type_rfp, #project_type_one_off, #project_type_full_time', (e) ->
  filter_project_form($('.project_type .active input').val())