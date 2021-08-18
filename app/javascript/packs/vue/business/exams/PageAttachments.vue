<template lang="pug">
  .policy-details.position-relative
    h3.policy-details__title Documents
    .policy-actions
      a.btn.btn-default Download
      a.btn.m-l-1.btn-dark Create Documents
    .policy-details__body
      DocumentsTable(:currentExam="currentExam")

</template>

<script>
  import DocumentsTable from "./components/DocumentsTable";
  export default {
    props: ['currentExam'],
    components: {
      DocumentsTable
    },
    data() {
      return {

      }
    },
    created() {
    },
    methods: {

    },
    computed: {

    },
  }
</script>
