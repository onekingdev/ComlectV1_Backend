if Stripe?
  Stripe.setPublishableKey _appConfig.stripePublishableKey

$(document).on 'submit', '#new_payment_source_ach', (e) ->
  $form = $(this)
  e.preventDefault()
  $form.find('.alert-danger').text('').addClass('hidden')
  Stripe.bankAccount.createToken
    country: $('#payment_source_ach_country').val(),
    currency: $('#payment_source_ach_currency').val(),
    routing_number: $('#payment_source_ach_routing_number').val(),
    account_number: $('#payment_source_ach_account_number').val(),
    account_holder_name: $('#payment_source_ach_account_holder_name').val(),
    account_holder_type: $('#payment_source_ach_account_holder_type').val()
  , (status, response) ->
    if response.error
      $form.find('.alert-danger').text(response.error.message).removeClass('hidden')
    else
      $.ajax
        url: $form.attr('action')
        method: 'POST'
        dataType: 'script'
        data:
          'payment_source_ach[token]': response.id
          'payment_source_ach[stripe_id]': response.bank_account.id
          'payment_source_ach[country]': response.bank_account.country
          'payment_source_ach[currency]': response.bank_account.currency
          'payment_source_ach[brand]': response.bank_account.bank_name
          'payment_source_ach[last4]': response.bank_account.last4
          'payment_source_ach[account_holder_name]': response.bank_account.account_holder_name
          'payment_source_ach[account_holder_type]': response.bank_account.account_holder_type
