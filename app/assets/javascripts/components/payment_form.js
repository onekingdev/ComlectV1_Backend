var patch_payment_form = function() {
  if ($('.payment_form').length > 0) {
    let stripe = Stripe(_appConfig.stripePublishableKey);
    let elements = stripe.elements();
    let card = elements.create('card');
    let displayError = $('#card-errors');
    let form = $('#payment_method_form');
    let submitButton = $('#submit-ongoing');
    let displayCouponError = $('#coupon-errors');
    let couponId;

    isLoading(true);

    card.mount('.stripe-card-form');
    card.on('change', function(event) {
      if (event.error) {
        setError(event.error.message);
      } else {
        if (
          form.find('#payment_form_plaid_token').val() === '' ||
          form.find('#payment_form_plaid_account_id').val() === '' ||
          form.find('#payment_form_plaid_institution').val() === ''
        ) {
          $('#payment_form_use_method').val('card');
        }
        setError('');
      }
    });

    function setError(message) {
      displayError.text(message);
      isLoading(false);
    }

    function setCouponError(message) {
      displayCouponError.text(message);
      isLoading(false);
    }

    function verifyCoupon(){
      return new Promise((resolve, reject) => {
        if($("#coupon-input").val()==""){
          resolve("");
        } else {
          fetch('/business/settings/payment/apply_coupon', {
            method: 'POST',
            body: JSON.stringify({
              coupon: $("#coupon-input").val(),
            })})
            .then((response) => response.json())
            .then((data) => {
              if (data.is_valid){
                couponId = data.coupon_id;
                resolve(data.message);
              } else {
                reject(data.message);
              }
          })
        }
      });  
    }

    function createCardToken() {
      return new Promise((resolve, reject) => {
        stripe.createToken(card).then(function (result) {
          if (result.token) {
            $('#payment_form_card_token').val(result.token.id);
            cardToken = result.token.id;
            resolve(result);
          } else {
            reject(result);
          }
        });
      });
    }
    function createPaymentMethod(options) {
      return new Promise((resolve, reject) => {
        data = {
          authenticity_token: form.find('input[name="authenticity_token"]').val(),
          coupon_id: options.coupon
        }
        if (options.stripeToken !== undefined || options.stripeToken !== '' || options.stripeToken !== null) {
          data.stripeToken = options.stripeToken
        }
        if (options.payment_source_ach !== undefined || options.payment_source_ach !== {} || options.payment_source_ach !== null) {
          data.payment_source_ach = options.payment_source_ach
        }

        $.post(
          form.attr('action') + '.json',
          data,
          (res) => resolve(res)
        )
        .error((e) => reject(e));
      });
    }
    function isLoading(state) {
      if (state === true) {
        submitButton.attr('disabled', true);
        //submitButton.text('loading...');
      } else {
        submitButton.attr('disabled', false);
        submitButton.text('Submit');
      }
    }
    function submitMainForm() {
      isLoading(true);
      $('.simple_form.checkout').submit();
    }

    $('.loading').hide();
    $('.payment_form').show();
    isLoading(false);

    $('.plaid-link').on('click', function(e) {
      e.preventDefault();

      this.plaidLinkHandler = Plaid.create({
        env: $(this).data('env'),
        clientName: $(this).data('client-name'),
        key: $(this).data('public-key'),
        product: ['auth'],
        selectAccount: true,
        onSuccess: function(publicToken, metadata) {
          form.find('#payment_form_plaid_token').val(publicToken);
          form.find('#payment_form_plaid_account_id').val(metadata.account_id);
          form.find('#payment_form_plaid_institution').val(metadata.institution.name);

          // card.clear();
          submitButton.click();
        },
        onExit: function(err, metadata) {
          if (err == null) {
            $('#payment_form_use_method').val('card');
            card.update({ disabled: false });
          } else {
            setError(err.display_message);
          }
          isLoading(false);
        },
      });
      this.plaidLinkHandler.open();
      // card.clear();
      card.update({ disabled: true });
      isLoading(true);
      $('#payment_form_use_method').val('plaid');
    });

    submitButton.on('click', function(e) {
      e.preventDefault();
      isLoading(true);
      if ($('#payment_form_use_method').val() === 'card') {
        verifyCoupon().then(q => {
          createCardToken().then(e => {
            const options = {
              stripeToken: $('#payment_form_card_token').val(),
              coupon: couponId
            }
            createPaymentMethod(options).then(e2 => {
              if (e2.redirectTo !== undefined) {
                isLoading(true);
                window.location.href = e2.redirectTo;
              }
              submitMainForm();
              if (window.location.pathname.indexOf("/business/settings") > -1) {
                window.location.href = "/business/settings/payment";
              }
            })
            .catch((e) => setError(e.responseJSON.message));
          })
          .catch((e) => setError(e.error.message));
        }).catch((e) => setCouponError(e));
      } else {
        const options = {
          payment_source_ach: {
            plaid_token: $('#payment_form_plaid_token').val(),
            plaid_account_id: $('#payment_form_plaid_account_id').val(),
            plaid_institution: $('#payment_form_plaid_institution').val(),
            coupon: coupon
          }
        }
        createPaymentMethod(options).then(res => {
          submitMainForm();
        })
        .catch((e) => setError(e.message));
      }
    });
  }
};

if ((window.location.pathname.indexOf("/business/onboarding") > -1) || (window.location.pathname.indexOf("/specialist/settings/payment") > -1)) {
  $(document).ready(function () {
    patch_payment_form();
  });
}
