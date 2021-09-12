<template lang="pug">
  div
    Errors(:errors="errors.base")
    br(v-if="errors.base")

    b-form(@submit="onSubmit")
      #step1.form.d-block
        .row
          .col-md-6
            .row
              .col
                b-form-group#inputB-group-4(
                  label="Account type"
                  label-class="required"
                  label-for="account_type"
                )

                  div(:class="{'invalid': errors.account_type}")
                    multiselect#account_type(
                      required
                      label="name"
                      track-by="name"
                      :multiple="false"
                      :show-labels="false"
                      v-model="account_type"
                      @input="onChangeSelect"
                      :options="accountTypeOptions"
                      placeholder="Select account type"
                    )
                    Errors(:errors="errors.account_type")

            .row(v-if="(account_type && account_type.value) === 'individual'")
              .col-sm.pr-sm-2
                b-form-group#inputB-group-2(
                  label-for="first_name"
                  label-class="required"
                  label="Legal first name"
                )
                  b-form-input#first_name(
                    type="text"
                    v-model="first_name"
                    placeholder="Legal first name"
                    @input="onChangeInput('first_name')"
                    :class="{'is-invalid': errors.first_name}"
                  )
                  Errors(:errors="errors.first_name")
              .col-sm.pl-sm-2
                b-form-group#inputB-group-3(
                  label-for="last_name"
                  label-class="required"
                  label="Legal last name"
                )
                  b-form-input#last_name(
                    type="text"
                    v-model="last_name"
                    placeholder="Legal last name"
                    @input="onChangeInput('last_name')"
                    :class="{'is-invalid': errors.last_name }"
                  )
                  Errors(:errors="errors.last_name")

            .row(v-if="(account_type && account_type.value) === 'company'")
              .col
                b-form-group#inputB-group-2(
                  label-for="business_name"
                  label-class="required"
                  label="Legal business name"
                )
                  b-form-input#business_name(
                    type="text"
                    v-model="business_name"
                    placeholder="Legal business name"
                    @input="onChangeInput('business_name')"
                    :class="{'is-invalid': errors.business_name}"
                  )
                  Errors(:errors="errors.business_name")

            .row
              .col
                b-form-group#inputB-group-4(
                  label="Country"
                  label-for="country"
                  label-class="required"
                )

                  div(:class="{'invalid': errors.country}")
                    multiselect#country(
                      required
                      label="name"
                      track-by="name"
                      :multiple="false"
                      v-model="country"
                      :show-labels="false"
                      @input="onChangeSelect"
                      :options="countryOptions"
                      placeholder="Select country"
                    )
                    Errors(:errors="errors.country")

        .row
          .col
            .text-right
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
  import Multiselect from "vue-multiselect";

  export default {
    name: "AccountInformation",
    props: ["stripeAccount"],
    components: { Multiselect },
    data() {
      return {
        errors: {},
        country: this.stripeAccount.country,
        last_name: this.stripeAccount.last_name,
        first_name: this.stripeAccount.first_name,
        account_type: this.stripeAccount.account_type,
        business_name: this.stripeAccount.business_name,

        accountTypeOptions: [
          { value: "company", name: "Business" },
          { value: "individual", name: "Individual" }
        ],

        countryOptions: [
          { value: "AT", name: "Austria" },
          { value: "AU", name: "Australia" },
          { value: "BE", name: "Belgium" },
          { value: "CA", name: "Canada" },
          { value: "DE", name: "Germany" },
          { value: "DK", name: "Denmark" },
          { value: "ES", name: "Spain" },
          { value: "FI", name: "Finland" },
          { value: "FR", name: "France" },
          { value: "GB", name: "United Kingdom" },
          { value: "HK", name: "Hong Kong" },
          { value: "IE", name: "Ireland" },
          { value: "IT", name: "Italy" },
          { value: "JP", name: "Japan" },
          { value: "LU", name: "Luxembourg" },
          { value: "NL", name: "Netherlands" },
          { value: "NO", name: "Norway" },
          { value: "PT", name: "Portugal" },
          { value: "SE", name: "Sweden" },
          { value: "SG", name: "Singapore" },
          { value: "US", name: "United States" }
        ]
      }
    },
    methods: {
      onSubmit(e) {
        e.preventDefault();

        const data = {
          country: this.country?.value || "",
          account_type: this.account_type?.value || ""
        }

        if (this.stripeAccount.id) {
          data.id = this.stripeAccount.id
        }

        if (data.account_type === "individual") {
          data.last_name = this.last_name || ""
          data.first_name = this.first_name || ""
        }

        if (data.account_type === "company") {
          data.business_name = this.business_name || ""
        }

        const action = this.stripeAccount.id
          ? "stripe_accounts/updateStripeAccount"
          : "stripe_accounts/createStripeAccount"

        this.$store.dispatch(action, data).then((response) => {
          this.errors = response.errors || {}

          if (!response.error && !response.errors) {
            this.$emit("changeTab", "personal");
          }
        }).catch(error => {
          this.toast("Error", `Something wrong! ${error.message}`, true);
        });
      },
      onChangeInput(key) {
        if (this.errors[key]) delete this.errors[key]
      },
      onChangeSelect (_, key) {
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

  .btn.btn-dark {
    width: 76.2px;
  }
</style>
