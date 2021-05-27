<template lang="pug">
  .card-body.white-card-body.reviews__card.px-5(v-if="currentExam")
    .reviews__card--internal.p-y-1.d-flex.justify-content-between
      h3 Shared with me
    .reviews__topiclist
      template(v-if="currentExam.exam_requests" v-for="(currentRequst, i) in currentExam.exam_requests")
        .reviews__card--internal.exams__card--internal(:key="`${currentExam.name}-${i}`" :class="{ 'completed': currentRequst.complete }")
          .row.m-b-1
            .col-md-1
              .reviews__checkbox.d-flex.justify-content-between
                .reviews__checkbox-item.reviews__checkbox-item--true(:class="{'checked': currentRequst.complete }")
                  b-icon(icon="check2")
                .reviews__checkbox-item.reviews__checkbox-item--false(:class="{'checked': !currentRequst.complete }")
                  b-icon(icon="x")
            .col-md-11
              .d-flex.justify-content-between.align-items-center
                .d-flex
                  b-badge.mr-2(v-if="currentRequst.shared" variant="success") {{ currentRequst.shared ? 'Shared' : '' }}
                  .exams__input.exams__topic-name {{ currentRequst.name }}
          .row.m-b-1
            .col-md-11.offset-md-1
              p {{ currentRequst.details }}
          .row.m-b-1
            .col-md-11.offset-md-1
              .row
                .col
                  .d-flex.justify-content-between.align-items-center
                    span
                      b-icon.mr-2(:icon="currentRequst.text_items && currentRequst.text_items.length ? 'chevron-down' : 'chevron-right'")
                      | {{ currentRequst.text_items && currentRequst.text_items.length ? currentRequst.text_items.length : 0 }} Items
              hr(v-if="currentRequst.text_items")
              .row(v-if="currentRequst.text_items")
                template(v-for="(textItem, textIndex) in currentRequst.text_items")
                  .col-12.exams__text(:key="`${currentRequst.name}-${i}-${textItem}-${textIndex}`")
                    textarea.exams__text-body(v-model="currentRequst.text_items[textIndex].text")

              .row
                template(v-for="(file, fileIndex) in currentRequst.exam_request_files")
                  .col-md-6.m-b-1(:key="`${currentRequst.name}-${i}-${file}-${fileIndex}`")
                    .file-card
                      div.mr-2
                        b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                      div.ml-0.mr-auto
                        p.file-card__name: b {{ file.name }}
                        a.file-card__link.link(:href="file.file_url" target="_blank") Download
</template>

<script>
    export default {
        props: ['currentExam']
    }
</script>

<style scoped>

</style>
