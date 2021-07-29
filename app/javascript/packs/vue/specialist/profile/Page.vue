<template lang="pug">
  div.profile
    .container-fluid
      .row
        .col-md-9.mx-auto.mt-3
          .card
            .card-header
              h3.m-y-0 Profile
            .card-body.white-card-body
              b-tabs(content-class="mt-0")
                b-tab(title="My Profile")
                  MyProfile
                b-tab(title="Settings" active)
                  Settings
</template>

<script>
  import MyProfile from "./components/MyProfile";
  import Settings from "./components/Settings";

  export default {
    components: {
      MyProfile,
      Settings,
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

  .preview-switcher {
    display: flex;
  }

  .profile .nav-tabs {
    background-color: white;
    margin-bottom: 2.5rem;
  }

  .profile .nav-tabs .nav-item:not(:last-child) {
    margin-left: 0;
  }
</style>
