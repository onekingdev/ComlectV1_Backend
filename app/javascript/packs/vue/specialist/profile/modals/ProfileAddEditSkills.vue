<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Skills")
      .row
        .col
          b-form-group(label='Skills' class="onboarding-group m-b-30" label-for='selectS-8' label-class="label required")
            div(
            :class="{ 'invalid': errors.skills }"
            )
              multiselect#selectS-8(
              v-model="form.skills"
              :options="form.skillsTags"
              :multiple="true"
              :show-labels="false"
              track-by="name",
              label="name",
              tag-placeholder="Add this as new tag",
              placeholder="Search or add a tag",
              :taggable="true",
              @tag="addSkillsTag"
              required)
              .invalid-feedback.d-block(v-if="errors.skills") {{ errors.skills }}

      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn.link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  import Multiselect from 'vue-multiselect'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      form: {
        type: Object,
        required: true
      }
    },
    components: {
      Multiselect
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        errors: []
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('compliteConfirmed')
        this.$bvModal.hide(this.modalId)
      },
      addSkillsTag (newTag) {
        const tag = {
          name: newTag,
          code: newTag.substring(0, 2) + Math.floor((Math.random() * 10000000))
        }
        this.form.skillsTags.push(tag)
        this.form.skills.push(tag)
      },
    },
  }
</script>
