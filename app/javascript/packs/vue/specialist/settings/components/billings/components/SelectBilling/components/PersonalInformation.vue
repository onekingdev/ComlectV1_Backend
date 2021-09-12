<template lang="pug">
  div
    Errors(:errors="errors.base")
    br(v-if="errors.base")

    b-form(@submit="onSubmit")
      #step2.form
        div.d-flex.justify-content-between
          .text-left
            h3.onboarding__title
              | Tell us more about your {{ accountType === "company" ? "business" : "self" }}:
            p.onboarding__sub-title We will use this to verify your identity

        .row
          .col-sm-6.pr-sm-2
            InputDate(
              required
              v-model="dob"
              :errors="errors.dob"
              :options="datepickerOptions"
              labelKlass="d-block required"
              @input="onChangeInput('dob')"
            ) Date of birth

          .col-sm-6.pl-sm-2(v-if="accountType === 'individual'")
            b-form-group#inputB-group-7(
              label-class="required"
              label-for="personal_id_number"
              label="Last 4 digits of Security Social Number"
            )
              b-form-input#personal_id_number.form-control(
                type="text"
                v-model="personal_id_number"
                placeholder="Enter last 4 digits of SSN"
                @input="onChangeInput('personal_id_number')"
                :class="{'is-invalid': errors.personal_id_number}"
              )
              Errors(:errors="errors.personal_id_number")

          .col-sm-6.pr-sm-2(v-if="accountType === 'company'")
            b-form-group#inputB-group-7(
              label="Business tax"
              label-class="required"
              label-for="business_tax_id"
            )
              b-form-input#business_tax_id.form-control(
                type="text"
                placeholder="000000000"
                v-model="business_tax_id"
                @input="onChangeInput('business_tax_id')"
                :class="{'is-invalid': errors.business_tax_id}"
              )
              Errors(:errors="errors.business_tax_id")

        hr

        .row
          .col-xl-12.pr-xl-2
            b-form-group#inputB-group-9(
              label-for="inputB-9"
              label-class="required"
              :label="accountType === 'company' ? 'Business Address' : 'Home Address'"
            )
              vue-google-autocomplete#map(
                v-model="address1"
                placeholder="Address"
                classname="form-control"
                v-on:placechanged="getAddressData"
                :class="{'is-invalid': errors.address1}"
                @keypress.enter="$event.preventDefault()"
                :fields="['address_components', 'adr_address', 'geometry', 'formatted_address', 'name']"
              )
              Errors(:errors="errors.address1")

        .row
          .col-xl-4.pr-xl-2
            b-form-group#inputB-group-12(label="City" label-for="city" label-class="required")
              b-form-input#city(
                type="text"
                v-model="city"
                placeholder="City"
                @input="onChangeInput('city')"
                :class="{'is-invalid': errors.city}"
              )
              errors(:errors="errors.city")

          .col-xl-4.px-xl-2
            b-form-group#inputB-group-13(label="State" label-for="state" label-class="required")
              b-form-input#state(
                v-model="state"
                placeholder="Select state"
                @input="onChangeInput('state')"
                :class="{'is-invalid': errors.state}"
              )
              Errors(:errors="errors.state")

          .col-xl-4.pl-xl-2
            b-form-group#inputB-group-11(label="Zip" label-for="zipcode" label-class="required")
              b-form-input#zipcode(
                v-model="zipcode"
                placeholder="Zip"
                @input="onChangeInput('zipcode')"
                :class="{'is-invalid': errors.zipcode}"
              )
              Errors(:errors="errors.zipcode")

        .text-right.m-t-3
          b-button.mr-2(
            type="button"
            variant="default"
            @click="$emit('changeTab', 'account')"
          ) Go back

          b-button(v-show="!loading" type="submit" variant="dark") Next
          b-button(v-show="loading" type="button" :disabled="true")
            .lds-ring.lds-ring-small
              div
              div
              div
              div
            | {{ " Next" }}
</template>

<script>
  import moment from "moment";
  import VueGoogleAutocomplete from "vue-google-autocomplete";

  export default {
    name: "PersonalInformation",
    props: ["stripeAccount"],
    components: { VueGoogleAutocomplete },
    data() {
      return {
        errors: {},
        stateOptions: [],
        dob: this.stripeAccount.dob,
        city: this.stripeAccount.city,
        state: this.stripeAccount.state,
        zipcode: this.stripeAccount.zipcode,
        address1: this.stripeAccount.address1,
        business_name: this.stripeAccount.business_name,
        accountType: this.stripeAccount.account_type.value,
        business_tax_id: this.stripeAccount.business_tax_id,
        personal_id_number: this.stripeAccount.personal_id_number
      }
    },
    methods: {
      onSubmit(e) {
        e.preventDefault();

        const data = {
          section: "personal",
          dob: this.dob || "",
          city: this.city || "",
          state: this.state || "",
          id: this.stripeAccount.id,
          zipcode: this.zipcode || "",
          address1: this.address1 || "",
          personal_id_number: this.personal_id_number || ""
        }

        if (this.accountType === "company") {
          data.business_tax_id = this.business_tax_id || ""
        }

        this.$store.dispatch("stripe_accounts/updateStripeAccount", data).then((response) => {
          this.errors = response.errors || {}

          if (!response.error && !response.errors) {
            this.$emit("changeTab", "payout");
          }
        }).catch(error => {
          this.toast("Error", `Something wrong! ${error.message}`, true);
        });
      },
      onChangeInput(key) {
        if (this.errors[key]) delete this.errors[key]
      },
      getAddressData (addressData, placeResultData, id) {
        const input = document.getElementById(id);
        const { administrative_area_level_1, locality, postal_code } = addressData;

        this.city = locality;
        this.zipcode = postal_code;
        this.address1 = input.value;
        this.state = administrative_area_level_1;

        const fields = ["city", "zipcode", "address1", "state"]

        fields.forEach((key) => {
          if (this[key] && this[key].length && this.errors[key]) {
            delete this.errors[key];
          }
        });
      }
    },
    computed: {
      datepickerOptions() {
        return {
          max: moment().subtract(18, "years").format()
        }
      },
      loading() {
        return this.$store.getters.loading;
      }
    }
  }
</script>

<style scoped>
  .btn.btn-dark {
    width: 76.2px;
  }
</style>
