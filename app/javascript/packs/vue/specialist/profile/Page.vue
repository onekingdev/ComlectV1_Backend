<template lang="pug">
  div
    .container-fluid
      .row
        .col-md-9.mx-auto.mt-3
          .card
            .card-header
              h2 Profile
            .card-body.white-card-body
              MyProfile
            .card-body.white-card-body
              CompanyDetails
</template>

<script>
  import MyProfile from "./components/MyProfile";
  import CompanyDetails from "./components/CompanyDetails";

  export default {
    components: {
      MyProfile,
      CompanyDetails,
    },
  }
</script>

<style module>
  .preview {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 2rem;
    margin-bottom: 2rem;

    border: solid 1px #ced4da;
    border-radius: 3px;
    overflow: hidden;
  }

  .preview_sm {
    width: 6.25rem; /* 100px; */
    height: 6.25rem; /* 100px; */
  }

  .preview_md {
    width: 7.8125rem; /* 125px; */
    height: 7.8125rem; /* 125px; */
  }

  .preview_lg {
    width: 9.375rem; /* 150px; */
    height: 9.375rem; /* 150px; */
  }

  .preview img {
    width: 100%;
    object-fit: contain;
  }
</style>
