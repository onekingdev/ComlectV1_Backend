<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Plan")
      b-row.m-b-2
        b-col(cols='8')
          b-row
            b-col
              p Your organization currently has {{ plan.users }} registered users
          b-row.m-b-2
            b-col(class="pr-1")
              label.form-label Billing plan
              ComboBox(V-model="plan.billingPlan" :options="linkToOptions" placeholder="Select a billing plan")
              Errors(:errors="errors.billingPlan")
            b-col(class="pl-1")
              label.form-label Users
              input.form-control(v-model="plan.count" type="text" placeholder="Users" @keyup.enter="submit" ref="input")
              Errors(:errors="errors.count")
        b-col(cols='4')
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
              p.text-success You saved 50$/month
      b-row
        b-col
          h5.mb-3 Payment method
          b-form-group(v-slot='{ ariaDescribedby }')
            b-form-radio(v-model='selected' :aria-describedby='ariaDescribedby' name='some-radios' value='A') **** **** **** 4242 Visa
            b-form-radio(v-model='selected' :aria-describedby='ariaDescribedby' name='some-radios' value='B') Paypal (email@gmail.com)

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Update
</template>

<script>
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
        selected: ''
      }
    },
    methods: {
      focusInput() {
        this.$refs.input.focus();
      },
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },

      async submit (e) {
        e.preventDefault();
        this.errors = [];

        if (!this.plan.name) {
          this.errors.push('Name is required.');
          this.makeToast('Error', 'Name is required.')
          return;
        }
        if (this.plan.name.length <= 3) {
          this.errors.push({name: 'Name is very short, must be more 3 characters.'});
          this.makeToast('Error', 'Name is very short, must be more 3 characters.')
          return;
        }

        const plan = this.plan
        const data = {
          id: plan.id,
          name: plan.name,
          plan_start: plan.plan_start,
          plan_end: plan.plan_end,
          // regulatory_changes_attributes: plan.regulatory_changes,
          // material_business_changes: plan.material_business_changes,
          // plan_plan_employees_attributes: plan.plan_plan_employees
        }
        try {
          await this.$store.dispatch('plan/updateplan', data)
            .then((response) => {
              // console.log('response', response)
              if (response.errors) {
                for (const [key, value] of Object.entries(response.errors)) {
                  console.log(`${key}: ${value}`);
                  this.makeToast('Error', `${key}: ${value}`)
                  this.errors = Object.assign(this.errors, { [key]: value })
                }
                // console.log(this.errors)
                return
              }

              if (!response.errors) {
                this.makeToast('Success', "Saved changes to plan plan.")
                this.$emit('saved')
                this.$bvModal.hide(this.modalId)
              }
            })
            .catch((error) => console.error(error))

        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
    },
    computed: {
      linkToOptions() {
        return [
          {...toOption('Billed monthly')},
          {...toOption('Billed anually')}
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
