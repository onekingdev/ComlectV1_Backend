<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Set Role")
      p Please confirm the applicant you wish to hire.
      .card
        .card-body
          SpecialistDetails(:specialist="specialist")
          InputSelect(v-model="role" :options="specialistRoleOptions") Select Role
          .form-text.text-muted Determines the permissions the specialist will have access to

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Set
</template>

<script>
  import SpecialistDetails from './SpecialistDetails'
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
      SpecialistDetails
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        errors: [],
        role: Object.keys(SPECIALIST_ROLE_OPTIONS)[0]
      }
    },
    methods: {
      specialistRoleOptions: () => SPECIALIST_ROLE_OPTIONS,
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('saved', application.id, role)
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>
