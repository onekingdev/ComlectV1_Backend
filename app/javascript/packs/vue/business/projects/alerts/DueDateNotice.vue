<template lang="pug">
  b-alert(:show="show" variant="primary")
    .d-flex.align-items-center
      b-icon.m-r-2.m-l-1(icon="exclamation-triangle-fill" scale="2" variant="warning")
      .d-block.mr-auto
        h4: b The project's due date tommorow
        p.mb-0 Do you want to extend the dataline?
      ExtendDeadlineModal(@saved="$emit('saved')" :project-id="project.id")
        button.btn.btn-default Extend
</template>

<script>
  import { DateTime } from 'luxon'
  import ExtendDeadlineModal from '../ExtendDeadlineModal'
  export default {
    props: {
      project: {
        type: Object,
        required: true
      }
    },
    components: {
      ExtendDeadlineModal,
    },
    computed: {
      confirmModalId() {
        return (this.modalId || '') + '_confirm'
      },
      show () {
        const d = new Date;
        const tommorow = d.getDate() + 1
        const end = +this.project.ends_on.split('-')[2]
        return tommorow === end
      }
    }
  }
</script>

<style scoped>
  .alert-primary {
    background-color: #fff7e4;
    box-shadow: inset 5px 0 0 #ffc900;
  }
</style>
