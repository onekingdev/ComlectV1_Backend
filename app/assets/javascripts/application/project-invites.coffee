$(document).on 'change', '#project_invite_project_id', (e) ->
  $select = $(this)
  label = if $select.val().length > 0 then 'Send' else 'Create Project & Send'
  $select.parents('form').find('input[type=submit]').val label
