<template lang="pug">
  .p-3
    h3
      | {{ project.title }}
      a.btn.btn-dark(href) Edit
      a.btn.btn-default(:href='postHref') Post Project
    dl.row
      dt.col-sm-3 Title
      dd.col-sm-9 {{ project.title }}
      dt.col-sm-3 Start Date
      dd.col-sm-9 {{ project.starts_on | asDate }}
      dt.col-sm-3 Due Date
      dd.col-sm-9 {{ project.ends_on | asDate }}
      dt.col-sm-3 Details
      dd.col-sm-9 {{ project.description }}
      dt.col-sm-3 Members
      dd.col-sm-9
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  computed: {
    postHref() {
      return this.$store.getters.url('URL_POST_LOCAL_PROJECT', this.project.id)
    }
  }
}
</script>