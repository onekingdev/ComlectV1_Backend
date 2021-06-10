<template lang="pug">
  .container-fluid
    .row
      .col.text-center.px-0.position-relative
        .header-top.p-y-1
          p.mb-0: b Viewing Auditor's Portal
            a.link.m-l-1(href="/business/exam_management/") Exit
        .bg-black
    .row
      .col
        .container
          .row
            .col.m-b-2
              .card-body.white-card-body.reviews__card
                .greeting
                  ion-icon.greeting__icon(name="search-outline")
                  .greeting-text
                    h1.greeting-text__title Welcome
                    p.greeting-text__subtitle Click on the reqeust item below to view their contents and download any document
          .row
            .col
              Loading
              ExamReqeustsAuditorPortalExternal(v-if="!loading")
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import ExamReqeustsAuditorPortalExternal from "./components/ExamReqeustsAuditorPortalExternal";
  export default {
    props: ['examId'],
    components: {Loading, ExamReqeustsAuditorPortalExternal},
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  }
</script>

<style scoped>
  @import "./styles.css";

  .header-top {
    position: relative;
    z-index: 2;
    margin-bottom: 5rem;
    background-color: #ecf4ff;
  }
  .bg-black {
    position: absolute;
    z-index: 0;
    top: 0;
    right: 0;
    left: 0;
    bottom: 0;
    width: 100%;
    min-height: 180px;
    background: linear-gradient(155deg, #1b1c29 50%, #1b1c29 55%, #2d304f 60%);
  }

  .greeting {
    display: flex;
    padding: 1rem;
  }
  .greeting-text {
    display: flex;
    flex-direction: column;
  }
  ion-icon {
    font-size: 50px;
    color: #565759;
    --ionicon-stroke-width: 64px;
  }
  .greeting__icon {
    margin-right: 2rem;
  }
  .greeting-text__title {
    font-size: 2rem;
    font-weight: bold;
  }
  .greeting-text__subtitle {
    font-size: 1rem;
  }
</style>
