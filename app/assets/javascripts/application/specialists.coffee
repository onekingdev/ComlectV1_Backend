# disable Enter for form submission
$('#new_specialist').on 'keyup keypress', (e) ->
  keyCode = e.keyCode || e.which
  if keyCode == 13
    e.preventDefault()
    return false