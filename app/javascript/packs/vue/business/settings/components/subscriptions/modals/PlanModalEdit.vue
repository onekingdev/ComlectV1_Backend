<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Plan")
      b-row.m-b-2
        .col
          label.form-label New plan name
          input.form-control(v-model="plan.name" type="text" placeholder="Enter the name of your plan" @keyup.enter="submit" ref="input")
          Errors(:errors="errors.name")

      b-row.m-b-2
        .col-6
          label.form-label Start Date
          DatePicker(v-model="plan.plan_start")
          Errors(:errors="errors.plan_start")
        .col-6
          label.form-label Due Date
          DatePicker(v-model="plan.plan_end")
          Errors(:errors="errors.plan_end")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
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
        // plan: {
        //   name: '',
        //   description: 'N/A',
        //   sections: [],
        // },
        errors: []
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

  }
</script>
