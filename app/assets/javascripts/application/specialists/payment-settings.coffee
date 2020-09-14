$(document).on 'change', '#stripe_account_country, #stripe_account_account_type', (e) ->
  $this = $(this)
  $form = $this.parents('form')
  $form.attr('action', $form.data('edit-url')).attr('method', 'GET').submit()
