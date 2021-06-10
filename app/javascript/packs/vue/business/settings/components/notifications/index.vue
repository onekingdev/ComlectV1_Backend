<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Notifications
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row
                .col-md-8
                  b-form(@submit='onSubmit' @onchange="onChange" @reset="onReset" v-if='show')
                    .row.mb-2
                      .col-10
                        h4
                          b Tasks
                      .col.text-center IN-APP
                      .col.text-center EMAIL
                    .row.mb-2(v-for="(option, i) in notificationsTasksOptions" :key="'task'+i")
                      .col-10
                        .custom-checkbox.b-custom-control-lg.pl-0
                          label {{option.label}}
                      .col.text-center
                        input(type="checkbox" v-model="form.notificationsTasksApp[i]" name="taskApp" class="regular-checkbox")
                      .col.text-center
                        input(type="checkbox" v-model="form.notificationsTasksEmail[i]" name="taskEmail" class="regular-checkbox")
                    .row.m-t-1
                      .col-12
                        h4
                          b Projects
                    .row.mb-2(v-for="(option, i) in notificationsProjectsOptions" :key="'project'+i")
                      .col-10
                        .custom-checkbox.b-custom-control-lg.pl-0
                          label {{option.label}}
                      .col.text-center
                        input(type="checkbox" v-model="form.notificationsProjectApp[i]" name="projectApp" class="regular-checkbox")
                      .col.text-center
                        input(type="checkbox" v-model="form.notificationsProjectEmail[i]" name="projectEmail" class="regular-checkbox")
                    .row.m-t-1
                      .col-12
                        h4
                          b Email Updates
                      .col-md-6
                        b-form-group
                          b-form-checkbox(v-for="(option, i) in notificationsEmailOptions" v-model="form.notificationsEmail[i]" :key="'email'+i" size="lg" name="email") {{option.label}}
                    .row
                      .col
                        b-form-group.text-right
                          b-button.btn.link.mr-2(type='reset' variant='none') Cancel
                          b-button.btn(type='submit' variant='dark') Save
</template>

<script>
  import Loading from '@/common/Loading/Loading'

  const NOTIFICATIONS_TASKS_OPTIONS = [
    { label: 'When a task is created', value: '' },
    { label: 'When a task assigned to me', value: '' },
    { label: 'When a file is uploaded to a task', value: '' },
    { label: 'When someone comments on a task', value: '' },
    { label: 'When a task is compiled', value: '' },
    { label: 'When a task is overdue', value: '' },
  ]

  const NOTIFICATIONS_PROJECTS_OPTIONS = [
    { label: 'When new applicants bid for a project', value: '' },
    { label: 'When applicants message me', value: '' },
    { label: 'When a specialist accepts a project completition', value: '' },
    { label: 'When a specialist accepts a dedline extension', value: '' },
  ]

  const NOTIFICATIONS_EMAIL_OPTIONS = [
    { label: 'Monthly Compilance Newsletter', value: '' },
    { label: 'Promos and Upcomming Events', value: '' },
  ]

  const initialForm = () => ({
    notificationsTasksOptions: NOTIFICATIONS_TASKS_OPTIONS.map(() => false),
    notificationsProjectsOptions: NOTIFICATIONS_PROJECTS_OPTIONS.map(() => false),
    notificationsEmailOptions: NOTIFICATIONS_EMAIL_OPTIONS.map(() => false),
  })

  export default {
    components: {
      Loading,
    },
    data() {
      return {
        show: true,
        form: {
          notifications: initialForm(),
          notificationsTasksApp: [],
          notificationsTasksEmail: [],
          notificationsProjectApp: [],
          notificationsProjectEmail: [],
          notificationsEmail: []
        },
        errors: {},
        toggle: ''
      };
    },
    methods: {
      onSubmit (event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        console.log(this.form)
        return

        const data = {

        }

        this.$store.dispatch('....', data)
          .then((response) => console.log(error))
          .catch((error) => console.error(error))
      },
      onChange (value) {
        if(value) {
          console.log(value)
          console.log(this.form)
        }
      },
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.form = initialForm()
        this.form.checked = []
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      notificationsTasksOptions: () => NOTIFICATIONS_TASKS_OPTIONS,
      notificationsProjectsOptions: () => NOTIFICATIONS_PROJECTS_OPTIONS,
      notificationsEmailOptions: () => NOTIFICATIONS_EMAIL_OPTIONS,
    },
    mounted() {

    },
  };
</script>


<style>
  .regular-checkbox {
    -webkit-appearance: none;
    background-color: #fff;
    border: 1px solid #303132;
    /*box-shadow: 0 1px 2px rgba(0,0,0,0.05), inset 0px -15px 10px -12px rgba(0,0,0,0.05);*/
    padding: 9px;
    display: inline-block;
    position: relative;
    width: 1.25rem;
    height: 1.25rem;
    border-radius: 0.3rem;
    transition: background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  }

  .regular-checkbox:active, .regular-checkbox:checked:active {
    /*box-shadow: 0 1px 2px rgba(0,0,0,0.05), inset 0 1px 3px rgba(0,0,0,0.1);*/
  }

  .regular-checkbox:checked {
    position: relative;
    background-color: #303132;
    border: 1px solid #303132;
    /*box-shadow: 0 1px 2px rgba(0,0,0,0.05), inset 0px -15px 10px -12px rgba(0,0,0,0.05), inset 15px 10px -12px rgba(255,255,255,0.1);*/
    color: #fff;
  }

  .regular-checkbox:checked:after {
    position: absolute;
    width: 100%;
    height: 100%;
    background-size: 70% 70%;
    background-color: #303132;
    background-repeat: no-repeat;
    background-position: center;
    /*background: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' width='8' height='8' viewBox='0 0 8 8'%3e%3cpath fill='%23fff' d='M6.564.75l-3.59 3.612-1.538-1.55L0 4.26l2.974 2.99L8 2.193z'/%3e%3c/svg%3e") no-repeat 50% / 50% 50%;*/
    /*content: '\2714';*/
    content: '';
    /*font-size: 10px;*/
    /*position: absolute;*/
    /*top: -1px;*/
    /*left: 3px;*/
    /*color: #fff;*/
    /*border: solid 1px red;*/
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' width='8' height='8' viewBox='0 0 8 8'%3e%3cpath fill='%23fff' d='M6.564.75l-3.59 3.612-1.538-1.55L0 4.26l2.974 2.99L8 2.193z'/%3e%3c/svg%3e");
  }

  /*
  .big-checkbox {
    padding: 18px;
  }

  .big-checkbox:checked:after {
    font-size: 28px;
    left: 6px;
  }
  */
</style>
