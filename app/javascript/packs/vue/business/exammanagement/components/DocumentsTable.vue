<template lang="pug">
  div
    .row(v-for="(currentRequest, reqIdx) in currentExam.exam_requests" :key="reqIdx")
      template(v-for="(file, fileIndex) in currentRequest.exam_request_files")
        .col-md-6.m-b-1(:key="`${currentRequest.id}--${file}-${fileIndex}`")
          .file-card
            div.mr-2
              b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
            div.ml-0.mr-auto
              p.file-card__name: b {{ file.name }}
              a.file-card__link.link(:href="file.file_url" target="_blank") Download
            div.ml-auto.align-self-start.actions
              b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
                template(#button-content)
                  b-icon(icon="three-dots")
                b-dropdown-item.delete Delete file
    .row(v-if="!currentExam.exam_requests")
      .col
        table.table.task_table
          tbody
            tr
              td.text-center
                h3 No documents
</template>

<script>
  export default {
    props: ['currentExam'],
  }
</script>

<style scoped>
  .link {
    max-width: 400px;
    word-break: break-all;
  }
</style>
