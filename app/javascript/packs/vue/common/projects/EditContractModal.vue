<template lang="pug">
  div(:class="{'d-inline-block w-100':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block w-100':inline}")
      slot: button.btn.btn-outline-dark.float-right Edit
    b-modal(:id="modalId" title="Edit Contract")
      .row
        .col-md-12
          h3 Terms
          .row
            .col-sm: InputDate(v-model="form.starts_on" :errors="errors.starts_on") Start Date
            .col-sm: InputDate(v-model="form.ends_on" :errors="errors.ends_on") Due Date
          InputText.m-t-1(v-if="form.hourly_rate == null" v-model="form.fixed_budget" :errors="errors.fixed_budget") Fixed Budget
          InputText.m-t-1(v-else v-model="form.hourly_rate" :errors="errors.hourly_rate") Hourly Rate
          hr
          h3 Role
          InputTextarea.m-t-1(v-model="form.role_details" :errors="errors.role_details" :rows="4") Role Details
          InputTextarea.m-t-1(v-model="form.key_deliverables" :errors="errors.key_deliverables" :rows="4") Key Deliverables
          h3.m-t-1 Attachments
          .card.m-b-1
            .card-body
              p
                | Drop files here or
                a.btn.btn-light Upload Files
      template(#modal-footer="{ hide }")
        button.btn.btn-link.mr-2(@click="hide") Cancel
        Post(:action="`/api/projects/${project.id}/extension`" :model="form" @errors="errors = $event" @saved="saved")
          button.btn.btn-dark Resubmit
</template>

<script>
const initialForm = (project) => ({
  starts_on: project.starts_on || null,
  ends_on: project.ends_on || null,
  fixed_budget: project.fixed_budget ? parseInt(project.fixed_budget) : null,
  hourly_rate: project.hourly_rate ? parseInt(project.hourly_rate) : null,
  key_deliverables: project.key_deliverables || null,
  role_details: project.role_details || null,
})
const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

export default {
  props: {
    project: {
      type: Object,
      required: true
    },
    inline: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      modalId: `modal_${rnd()}`,
      form: initialForm(this.project),
      errors: {}
    }
  },
  methods: {
    saved() {
      this.$bvModal.hide(this.modalId)
      this.toast('Success', 'Modification requested.')
      this.$emit('saved')
    }
  }
}
</script>
