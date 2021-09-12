<template lang="pug">
  div
    Errors(:errors="errors.base")
    br(v-if="errors.base")

    b-form(@submit="onSubmit")
      #step3.form
        .row
          .col-md-6
            div.d-flex.justify-content-between
              .text-left
                h3.onboarding__title Tell us where you'd like to recieve your payments

            .row
              .col
                b-form-group#inputB-group-7(
                  label="Routing Number"
                  label-class="required"
                  label-for="routing_number"
                )
                  b-form-input#routing_number.form-control(
                    type="text"
                    placeholder="110000000"
                    v-model="routing_number"
                    @input="onChangeInput('routing_number')"
                    :class="{'is-invalid': errors.routing_number}"
                  )
                  Errors(:errors="errors.routing_number")

            .row
              .col
                b-form-group#inputB-group-7(
                  label="Account Number"
                  label-class="required"
                  label-for="account_number"
                )
                  b-form-input#account_number.form-control(
                    type='text'
                    v-model="account_number"
                    placeholder='000123456789'
                    @input="onChangeInput('account_number')"
                    :class="{'is-invalid': errors.account_number}"
                  )
                  Errors(:errors="errors.account_number")

            .row
              .col
                b-form-group#inputB-group-7(
                  label-class="required"
                  label="Confirm Account Number"
                  label-for="account_number_confirmation"
                )
                  b-form-input#account_number_confirmation.form-control(
                    type="text"
                    placeholder="000123456789"
                    v-model="account_number_confirmation"
                    @input="onChangeInput('account_number_confirmation')"
                    :class="{'is-invalid': errors.account_number_confirmation}"
                    )
                  Errors(:errors="errors.account_number_confirmation")

        .col.text-right.mt-3
          b-button.mr-2(
            type="button"
            variant="default"
            @click="$emit('changeTab', 'personal')"
          ) Go back

          b-button(v-show="!loading" type="submit" variant="dark") Submit
          b-button(v-show="loading" type="button" :disabled="true")
            .lds-ring.lds-ring-small
              div
              div
              div
              div
            | {{ " Submit" }}
</template>

<script>
  export default {
    name: "PayoutInformation",
    data() {
      return {
        errors: {},
        routing_number: "",
        account_number: "",
        account_number_confirmation: ""
      }
    },
    methods: {
      onSubmit(e) {
        e.preventDefault();

        const data = {
          routing_number: this.routing_number || "",
          account_number: this.account_number || "",
          account_number_confirmation: this.account_number_confirmation || ""
        }

        const action = "bank_accounts/createBankAccount";
        this.$store.dispatch(action, data).then((response) => {
          this.errors = response.errors || {}

          if (!response.error && !response.errors) {
            this.toast("Success", "Done!");
            window.location.reload(true);
          }
        }).catch(error => {
          this.toast("Error", `Something wrong! ${error.message}`, true);
        });
      },
      onChangeInput(key) {
        if (this.errors[key]) delete this.errors[key]
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      }
    }
  }
</script>

<style scoped>
  .btn.btn-dark {
    width: 92.8px;
  }
</style>
