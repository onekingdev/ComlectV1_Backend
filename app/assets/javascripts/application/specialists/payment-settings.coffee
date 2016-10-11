$(document).on 'change', '#stripe_account_account_type_individual, #stripe_account_account_type_business', (e) ->
  $this = $(this)
  $this.parents('form').attr('data-account-type', $this.val())

$(document).on 'click', '.js-specialist-payment-settings', (e) ->
  e.preventDefault()
  _Modal.showPlain($('#specialist-payment-choose-country'));
