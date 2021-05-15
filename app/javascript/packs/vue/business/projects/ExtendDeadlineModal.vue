<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot
    b-modal.fade(:id="modalId" title="Extend Deadline" @show="newEtag")
      ModelLoader(:url="projectId ? submitUrl : undefined" :default="initialProject" :etag="etag" @loaded="loadProject")

        InputDate(v-model="project.ends_on" :errors="errors.ends_on" :options="datepickerOptions") New Due Date

        template(slot="modal-footer")
          button.btn.btn-light(@click="$bvModal.hide(modalId)") Cancel
          Post(:action="submitUrl" :model="project" :method="httpMethod" @errors="errors = $event" @saved="saved")
            button.btn.btn-dark Confirm
</template>

<script>
import EtaggerMixin from '@/mixins/EtaggerMixin'

const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

const initialProject = () => ({
  ends_on: null,
})

export default {
  mixins: [EtaggerMixin()],
  props: {
    inline: {
      type: Boolean,
      default: true
    },
    projectId: Number,
  },
  data() {
    return {
      modalId: `modal_${rnd()}`,
      project: initialProject(),
      errors: {}
    }
  },
  methods: {
    loadProject(project) {
      this.project = Object.assign({}, this.project, project)
    },
    saved() {
      this.$emit('saved')
      this.toast('Success', 'The project has been saved')
      this.$bvModal.hide(this.modalId)
      this.newEtag()
    }
  },
  computed: {
    initialProject: () => initialProject,
    submitUrl() {
      const toId = this.projectId ? `/${this.projectId}` : ''
      return '/api/business/local_projects' + toId
    },
    httpMethod() {
      return this.projectId ? 'PUT' : 'POST'
    },
    datepickerOptions() {
      return {
        min: new Date
      }
    },
  },
}
</script>
