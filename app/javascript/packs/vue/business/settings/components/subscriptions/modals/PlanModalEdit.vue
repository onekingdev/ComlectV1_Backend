<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Plan" @shown="getData")
      b-row.m-b-2
        b-col(cols="8").pr-0
          b-row
            b-col
              p Your organization currently has {{ plan.users }} registered users
          b-row.m-b-2
            b-col(class="pr-1")
              label.form-label Billing plan
              ComboBox(V-model="plan.billingPlan" :options="linkToOptions" placeholder="Select a billing plan" @input="selectPlan")
              Errors(:errors="errors.billingPlan")
            b-col(class="pl-1")
              label.form-label Users
              input.form-control(v-model="plan.count" type="number" placeholder="Users" ref="input" min="0" @keyup.enter="submit" @input="calcPrice")
              Errors(:errors="errors.count")
        b-col
          b-card.mb-2
            b-card-text
              p.form-label.text-uppercase.mb-0 Users
              p
                b 100$
                | /month
              p.form-label.text-uppercase.mb-0 Total
              p
                b 150$
                | /month
              p.text-success.mb-0(v-if="showDiscount") You saved 50$/month
      b-row
        b-col
          h5.mb-3 Payment method
          b-form-group(v-slot='{ ariaDescribedby }')
            b-form-radio(v-for="(paymentMethod, i) in paymentMethods" :key="i" v-model='selected' :aria-describedby='ariaDescribedby' name='radiosPaymentMethods' :value='paymentMethod.id') **** **** **** {{ paymentMethod.last4 }} {{ paymentMethod.brand }}

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Update
</template>

<script>
  import { mapGetters, mapActions } from "vuex"

  const toOption = id => ({ id, label: id })
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      plan: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        errors: [],
        selected: '',
        showDiscount: false
      }
    },
    methods: {
      ...mapActions({
        getPaymentMethod: 'settings/getPaymentMethod'
      }),
      focusInput() {
        this.$refs.input.focus();
      },
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },

      async submit (e) {
        e.preventDefault();
        this.errors = [];

        try {
          console.log(this.plan, this.selected)
        } catch (error) {
          console.error(error)
        }
      },
      selectPlan(value) {
        if (value==='anually') {
          this.showDiscount = true
          this.calcPrice(this.$refs.input.value)
        }
      },
      calcPrice (event) {
        const reqiredUsers = this.$refs.input.value;
        if(this.showDiscount && reqiredUsers && reqiredUsers >= 1) console.log(reqiredUsers)
      },
      async getData () {
        try {
          const data = {
            userType: 'business',
          }
          await this.getPaymentMethod(data)
            .then(response => response)
            .catch(error => console.error(error))
        } catch (error) {
          console.error(error)
          this.toast('Error', error.message)
        }
      },
    },
    computed: {
      ...mapGetters({
        paymentMethods: 'settings/paymentMethods'
      }),
      linkToOptions() {
        return [
          {
            id: 'monthly',
            label: 'Billed monthly',
          },
          {
            id: 'anually',
            label: 'Billed anually',
          }
        ]
      },
    }
  }
</script>

<style scoped>
  .form-label {
    color: #828487;
  }
</style>
