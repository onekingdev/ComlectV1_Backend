$(document).on 'change', '#stripe_account_country, #stripe_account_account_type', (e) ->
  $this = $(this)
  $form = $this.parents('form')
  $form.attr('action', $form.data('edit-url')).attr('method', 'GET').submit();

$(document).on 'submit', '#payment_method_form', (e) ->
  $form = $(this)
  return if $form.hasClass('js-payment-country')
  e.preventDefault()
  $form.find('.alert-danger').text('').addClass('hidden')
  stripe = Stripe _appConfig.stripePublishableKey unless stripe
  stripe.createToken('bank_account', {
    country: $('#specialist_payment_source_country').val(),
    currency: $('#specialist_payment_source_currency').val(),
    routing_number: $('#specialist_payment_source_routing_number').val(),
    account_number: $('#specialist_payment_source_account_number').val(),
    account_holder_name: $('#specialist_payment_source_account_holder_name').val(),
    account_holder_type: $('#specialist_payment_source_account_holder_type').val()
  })
  .then (response) ->
    if response.error
      $form.find('.alert-danger').text(response.error.message).removeClass('hidden')
    else
      $.ajax
        url: $form.attr('action')
        method: 'POST'
        dataType: 'json'
        data:
          'payment_source[token]': response.token.id
          'payment_source[stripe_id]': response.token.bank_account.id
          'payment_source[country]': response.token.bank_account.country
          'payment_source[currency]': response.token.bank_account.currency
          'payment_source[brand]': response.token.bank_account.bank_name
          'payment_source[last4]': response.token.bank_account.last4
          'payment_source[account_holder_name]': response.token.bank_account.account_holder_name
          'payment_source[account_holder_type]': response.token.bank_account.account_holder_type
      .error (res) ->
        $form.find('.alert-danger').text(res.responseJSON.message).removeClass('hidden');
      .success (res) ->
        console.log(res.redirectTo);
        window.location.href = res.redirectTo
