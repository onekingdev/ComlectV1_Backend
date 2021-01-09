<template>
  <div class="row">
    <div class="col-md-7 col-sm-12">
      <Calendar v-bind="{pdfUrl}"/>
    </div>
    <div class="col-md-5 col-sm-12">
      <h3>Bar colors</h3>
      <dl>
        <dt><span class="task-is-task">✅</span></dt>
        <dd>Tasks</dd>
        <dt><span class="task-is-project">📄</span></dt>
        <dd>Projects</dd>
        <dt><span class="task-is-overdue">⚠️</span></dt>
        <dd>Overdue</dd>
        <dt><span class="task-is-complete">✅</span></dt>
        <dd>Complete</dd>
      </dl>
    </div>
  </div>
</template>

<script>
import Calendar from './Calendar'

export default {
  props: {
    pdfUrl: {
      type: String,
      required: true
    }
  },
  components: {
    Calendar
  }
}
</script>