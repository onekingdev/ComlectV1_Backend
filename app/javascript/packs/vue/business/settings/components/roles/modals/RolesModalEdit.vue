<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Role")
      b-row.m-b-2
        .col
          .card
            .card-body
              .d-flex
                UserAvatar(:user="specialist")
                .d-block.m-l-2
                  h4: b {{ specialist.first_name + ' ' +  specialist.last_name }}
                  p.mb-1 {{ specialist.state }}
                  .d-flex.py-2
                    b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                    b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                    b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                    b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                    b-icon(icon='star' variant="warning" font-scale="1.5")
              hr
              InputSelect(v-model="role" :options="specialistRoleOptions") Select Role
              .form-text.text-muted Determines the permissions the specialist will have access to

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import { SPECIALIST_ROLE_OPTIONS } from '@/common/ProjectInputOptions'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      specialist: {
        type: Object,
        required: true
      }
    },
    components: {
      UserAvatar,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        // specialist: {
        //   name: '',
        //   description: 'N/A',
        //   sections: [],
        // },
        errors: [],
        role: Object.keys(SPECIALIST_ROLE_OPTIONS)[0]
      }
    },
    methods: {
      async submit (e) {
        e.preventDefault();
        this.errors = [];

        if (!this.specialist.name) {
          this.errors.push('Name is required.');
          this.toast('Error', 'N - Required field', true)
          return;
        }
        if (this.specialist.name.length <= 3) {
          this.errors.push({name: 'Name is very short, must be more 3 characters.'});
          this.toast('Error', 'N- Name must be more than 3 characters', true)
          return;
        }

        const specialist = this.specialist
        const data = {
          id: specialist.id,
          name: specialist.name,
          specialist_start: specialist.specialist_start,
          specialist_end: specialist.specialist_end,
          // regulatory_changes_attributes: specialist.regulatory_changes,
          // material_business_changes: specialist.material_business_changes,
          // annual_specialist_employees_attributes: specialist.annual_specialist_employees
        }
        try {
          await this.$store.dispatch('annual/updatespecialist', data)
            .then((response) => {
              // console.log('response', response)
              if (response.errors) {
                for (const [key, value] of Object.entries(response.errors)) {
                  console.log(`${key}: ${value}`);
                  this.toast('Error', `Changes have not been saved. Please try again. ${key}: ${value}`, true)
                  this.errors = Object.assign(this.errors, { [key]: value })
                }
                // console.log(this.errors)
                return
              }

              if (!response.errors) {
                this.toast('Success', "Changes have been saved.")
                this.$emit('saved')
                this.$bvModal.hide(this.modalId)
              }
            })
            .catch((error) => console.error(error))

        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
    },
    computed: {
      specialistRoleOptions: () => SPECIALIST_ROLE_OPTIONS,
    }
  }
</script>
