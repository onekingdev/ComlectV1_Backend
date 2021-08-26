<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Plan" size="lg" @shown="getData")
      b-row.m-b-2
        b-col(cols="8").pr-0
          b-row
            b-col
              p Your organization currently has {{ plan.users }} acive users
          b-row.m-b-2
            b-col(class="pr-1")
              label.form-label Billing plan
              ComboBox(V-model="plan.billingPlan" :options="linkToOptions" placeholder="Select a billing plan" @input="selectPlan")
              Errors(:errors="errors.billingPlan")
            b-col(class="pl-1")
              label.form-label Users
              input.form-control(v-model="additionalUsers" type="number" placeholder="Users" ref="input" min="0" @keyup.enter="submit" @input="calcPrice")
              Errors(:errors="errors.count")
        b-col
          b-card.mb-2
            b-card-text
              p.form-label.text-uppercase.mb-0 Users
              p
                b ${{ summary.usersCoast }}
                | /month
              p.form-label.text-uppercase.mb-0 Total
              p
                b ${{ summary.total }}
                | /month
              p.text-success.mb-0(v-if="showDiscount") You saved {{ summary.discount }}$/month
      b-row
        b-col
          h5.mb-3 Payment method
          b-form-group.px-2(v-slot='{ ariaDescribedby }')
            b-form-radio(v-for="(paymentMethod, i) in paymentMethods" :key="i" v-model='selected' :aria-describedby='ariaDescribedby' name='radiosPaymentMethods' :value='paymentMethod.id') **** **** **** {{ paymentMethod.last4 }} {{ paymentMethod.brand }}

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
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
        showDiscount: false,
        selectedPlan: '',
        additionalUsers: 0,
      }
    },
    methods: {
      ...mapActions({
        getPaymentMethod: 'settings/getPaymentMethod'
      }),
      focusInput() {
        this.$refs.input.focus();
      },
      async submit (e) {
        e.preventDefault();
        this.errors = [];

        try {
          console.log(this.plan, this.selected, this.additionalUsers)
        } catch (error) {
          console.error(error)
        }
      },
      selectPlan(value) {
        if (value==='anually') {
          this.showDiscount = true
          this.selectedPlan = 'anually'
          this.calcPrice(this.$refs.input.value)
        }
        if (value==='monthly' || value === '') {
          this.showDiscount = false
          this.selectedPlan = 'monthly'
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
          this.toast('Error', error.message, true)
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
      summary () {
        const billingType = this.selectedPlan
        let summary = {}
        if (billingType === 'anually') {
          const  usersCoast = this.additionalUsers * this.plan.additionalUserAnnually
          summary = {
            usersCoast,
            total: this.plan.coastAnnually + usersCoast,
            discount: Math.abs(this.plan.coastAnnually - this.plan.coastMonthly * 12)
          }
        }
        if (billingType === 'monthly') {
          const  usersCoast = this.additionalUsers * this.plan.additionalUserMonthly
          summary = {
            usersCoast,
            total: this.plan.coastMonthly + usersCoast
          }
        }
        return summary
      }
    }
  }
</script>

<style scoped>
  .form-label {
    color: #828487;
  }
</style>
