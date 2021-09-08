<template lang="pug">
  div
    div accountType - {{accountType}}
    div stripeAccount - {{stripeAccount}}
    b-form(@submit="onSubmit")
      #step2.form
        div.d-flex.justify-content-between
          .text-left
            h3.onboarding__title
              | Tell us more about your {{ accountType === "company" ? "business" : "self" }}:
            p.onboarding__sub-title We will use this to verify your identity

        .row(v-if="accountType === 'individual'")
          .col-sm-6.pr-sm-2
            InputDate(
              required
              v-model="date_of_birth"
              :options="datepickerOptions"
              :errors="errors.date_of_birth"
            ) Date of birth

          .col-sm-6.pl-sm-2
            b-form-group#inputB-group-7(
              label-for="last4ssn"
              label-class="required"
              label="Last 4 digits of Security Social Number"
            )
              b-form-input#last4ssn.form-control(
                type="text"
                v-model="last4ssn"
                placeholder="Enter last 4 digits of SSN"
                :class="{'is-invalid': errors.last4ssn}"
              )
              Errors(:errors="errors.last4ssn")

        .row(v-if="accountType === 'company'")
          .col-sm-6.pr-sm-2
            b-form-group#inputB-group-7(
              description="optional"
              label-for="business_name"
              label="Business operation name"
            )
              b-form-input#business_name.form-control(
                type="text"
                v-model="business_name"
                placeholder="Doing business as"
                :class="{'is-invalid': errors.business_name}"
              )
              Errors(:errors="errors.business_name")

          .col-sm-6.pl-sm-2
            b-form-group#inputB-group-7(
              label-for="website"
              description="Optional"
              label="Business Website"
            )
              b-form-input#website.form-control(
                type="text"
                v-model="website"
                placeholder="Business Website"
                :class="{'is-invalid': errors.website}"
              )
              Errors(:errors="errors.website")

        hr

        .row
          .col-xl-9.pr-xl-2
            b-form-group#inputB-group-9(
              label-for="inputB-9"
              label-class="required"
              :label="accountType === 'company' ? 'Business Address' : 'Home Address'"
            )
              vue-google-autocomplete#map(
                ref="address"
                v-model="address_1"
                placeholder="Address"
                classname="form-control"
                v-on:placechanged="getAddressData"
                :class="{'is-invalid': errors.address_1}"
                :fields="['address_components', 'adr_address', 'geometry', 'formatted_address', 'name']"
              )
              Errors(:errors="errors.address_1")

          .col-xl-3.pl-xl-2
            b-form-group#inputB-group-10(label='Apt/Unit:' label-for='inputB-10')
              b-form-input#inputB-10(
                type="text"
                v-model="apartment"
                placeholder="Apt/Unit"
                :class="{'is-invalid': errors.apartment}"
              )
              Errors(:errors="errors.apartment")

        .row
          .col-xl-4.pr-xl-2
            b-form-group#inputB-group-12(label="City" label-for="city" label-class="required")
              b-form-input#city(
                type="text"
                v-model="city"
                placeholder="City"
                :class="{'is-invalid': errors.city}"
              )
              errors(:errors="errors.city")

          .col-xl-4.px-xl-2
            b-form-group#inputB-group-13(label="State" label-for="state" label-class="required")
              div(:class="{'invalid': errors.state}")
                multiselect#state(
                  v-model="state"
                  :show-labels="false"
                  :options="stateOptions"
                  placeholder="Select state"
                )
                Errors(:errors="errors.state")

          .col-xl-4.pl-xl-2
            b-form-group#inputB-group-11(label="Zip" label-for="zipcode" label-class="required")
              b-form-input#zip(
                v-model="zipcode"
                placeholder="Zip"
                :class="{'is-invalid': errors.zipcode}"
              )
              Errors(:errors="errors.zipcode")

        .text-right.m-t-3
          b-button.mr-2(
            type="button"
            variant="default"
            @click="$emit('changeTab', 'account')"
          ) Go back

          b-button.mr-2(
            v-if="false"
            type="button"
            variant="outline-primary"
            @click="$emit('changeTab', 'account')"
          ) Skip this step

          b-button(type="submit" variant="dark") Next
</template>

<script>
  import Multiselect from "vue-multiselect";
  import VueGoogleAutocomplete from "vue-google-autocomplete";

  export default {
    name: "PersonalInformation",
    props: ["stripeAccount"],
    components: {
      Multiselect,
      VueGoogleAutocomplete
    },
    data() {
      return {
        errors: {},
        stateOptions: [],
        city: this.stripeAccount.city,
        state: this.stripeAccount.state,
        zipcode: this.stripeAccount.zipcode,
        website: this.stripeAccount.website,
        last4ssn: this.stripeAccount.last4ssn,
        apartment: this.stripeAccount.apartment,
        address_1: this.stripeAccount.address_1,
        date_of_birth: this.stripeAccount.date_of_birth,
        business_name: this.stripeAccount.business_name,
        accountType: this.stripeAccount.account_type.value
      }
    },
    methods: {
      getAddressData (addressData, placeResultData, id) {
        const input = document.getElementById(id);
        const { administrative_area_level_1, locality, postal_code } = addressData;

        this.city = locality;
        this.zipcode = postal_code;
        this.address_1 = input.value;
        this.state = administrative_area_level_1;
      },
      onSubmit(e) {
        e.preventDefault();

        const data = {
          section: "personal",
          city: this.city || "",
          state: this.state || "",
          id: this.stripeAccount.id,
          apartment: this.apartment,
          zipcode: this.zipcode || "",
          address_1: this.address_1 || "",
        }

        if (this.accountType === "individual") {
          data.last4ssn = this.last4ssn || ""
          data.date_of_birth = this.date_of_birth || ""
        }

        console.log("")
        console.log("data > ", data)
        console.log("")

        this.$store.dispatch("stripe_accounts/updateStripeAccount", data).then((response) => {
          if (response.errors) {
            for (const [key, value] of Object.entries(response.errors)) {
              this.errors = Object.assign({}, this.errors, { [key]: value })
            }
          }

          console.log("")
          console.log("response > ", response)
          console.log("")

          if (!response.error && !response.errors) {
            this.$emit("changeTab", "payout");
          }
        }).catch(error => {
          this.toast("Error", `Something wrong! ${error.message}`, true);
        });
      }
    },
    computed: {
      datepickerOptions() {
        return {
          min: new Date
        }
      },
    }
  }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>
  .multiselect {
    min-height: 20px;
  }
  .multiselect__placeholder {
    margin-bottom: 0;
    padding-top: 0;
    padding-bottom: 2px;
  }
  .multiselect__tags {
    min-height: 20px;
    padding: 5px 40px 0 10px;
    margin-bottom: 0;
    border-color: #ced4da;
    border-radius: 0.25rem;
  }
  .invalid .multiselect__tags {
    border-color: #CE1938;
  }
  .multiselect__tag {
    padding: 2px 26px 2px 10px;
    margin-bottom: 0;
    color: #0479ff;
    background: #ecf4ff;
  }
  .multiselect__tag-icon:after {
    color: #0479ff;
  }
  .multiselect__option--highlight {
    color: #0479ff;
    background: #ecf4ff;
  }
  .multiselect__option--highlight::after{
    background: #0479ff;
  }
  .multiselect__tag-icon {
    line-height: 1.2rem;
  }
  .multiselect__tag-icon:hover {
    color: white;
    background: #0479ff;
  }
  .multiselect__select {
    height: 30px;
  }
  .multiselect__single {
    margin-bottom: 0;
    font-size: 1.2rem;
    line-height: 14px;
  }
</style>
