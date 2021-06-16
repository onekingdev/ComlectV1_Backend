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
                  b-form(v-if='show')
                    .row.mb-2
                      .col
                        .d-flex.justify-content-between
                          h4
                            b Tasks
                          p.mb-0
                            span.mr-3 IN-APP
                            span EMAIL
                    .row
                      .col-10
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in notificationsTasksOptions" :key="'task-main-'+i")
                          label {{option.label}}
                      .col.text-center
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in form.in_app_notifications.tasks" :key="'task-app-'+i" )
                          input.mb-2(type="checkbox" v-model="checkedApps[i]" :value="form.in_app_notifications.tasks[i]" class="regular-checkbox" @change="onChange('in_app_notifications')")
                      .col.text-center
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in form.email_notifications.tasks" :key="'task-email-'+i" )
                          input.mb-2(type="checkbox" v-model="checkedEmails[i]" :value="form.email_notifications.tasks[i]" class="regular-checkbox" @change="onChange('email_notifications')")
                    .row.m-t-1
                      .col-12
                        h4
                          b Projects
                    .row.mb-2(v-for="(option, i) in notificationsProjectsOptions" :key="'project'+i")
                      .col-10
                        .custom-checkbox.b-custom-control-lg.pl-0
                          label {{option.label}}
                      .col.text-center
                        input(type="checkbox" v-model="form.in_app_notifications[i]" class="regular-checkbox" @change="onChange")
                      .col.text-center
                        input(type="checkbox" v-model="form.email_notifications[i]" class="regular-checkbox" @change="onChange")
                    .row.m-t-1
                      .col-12
                        h4
                          b Email Updates
                      .col-md-6
                        b-form-group
                          b-form-checkbox(v-for="(option, i) in notificationsEmailOptions" v-model="form.email_updates[i]" :key="'email'+i" size="lg" @change="onChange") {{option.label}}
                    .row.d-none
                      .col
                        b-form-group.text-right
                          b-button.btn.link.mr-2(type='reset' variant='none') Cancel
                          b-button.btn(type='submit' variant='dark') Save
</template>

<script>
  import Loading from '@/common/Loading/Loading'

  const NOTIFICATIONS_TASKS_OPTIONS = [
    { label: 'When a task is created' },
    { label: 'When a task assigned to me' },
    { label: 'When a file is uploaded to a task' },
    { label: 'When someone comments on a task' },
    { label: 'When a task is compiled' },
    { label: 'When a task is overdue' },
  ]

  const NOTIFICATIONS_PROJECTS_OPTIONS = [
    { label: 'When new applicants bid for a project' },
    { label: 'When applicants message me' },
    { label: 'When a specialist accepts a project completition' },
    { label: 'When a specialist accepts a dedline extension' },
  ]

  const NOTIFICATIONS_EMAIL_OPTIONS = [
    { label: 'Monthly Compilance Newsletter' },
    { label: 'Promos and Upcomming Events' },
  ]

  const initialForm = () => ({
    in_app_notifications: {
      tasks: {
        task_created: true,
        task_assigned: true,
        task_file_uploaded: true,
        task_new_comment: true,
        task_completed: true,
        task_overdue: true,
      },
      projects: {
        project_new_bid: true,
        project_message: true,
        project_overdue: true,
        project_ended: true,
        project_completed: true,
      },
      got: {
        got_rated: true,
        got_message: true,
      },
      emails: {
        new_forum_answers: true,
        new_forum_comments: true,
      },
    },
    email_notifications: {
      tasks: {
        task_created: true,
        task_assigned: true,
        task_file_uploaded: true,
        task_new_comment: true,
        task_completed: true,
        task_overdue: true,
      },
      projects: {
        project_new_bid: true,
        project_message: true,
        project_overdue: true,
        project_ended: true,
        project_completed: true,
      },
      got: {
        got_rated: true,
        got_message: true,
      },
      emails: {
        new_forum_question: true,
        new_forum_comments: true
      },
    },
    email_updates: {
      monthly_newsletter: true,
      promos_and_events: true
    }
  })

  export default {
    components: {
      Loading,
    },
    data() {
      return {
        show: true,
        form: initialForm(),
        errors: {},
        checkedApps: [],
        checkedEmails: []
      };
    },
    methods: {
      onChange (kind) {
        console.log('kind', kind)
        console.log(this.checkedApps)
        console.log(this.checkedApps[0])
        console.log(Object.keys(this.checkedApps)[0])

        let data;
        if (kind === 'in_app_notifications') {
          data = {
            "kind": "in_app_notifications",
            "setting": Object.keys(this.checkedApps)[0]
          }
        }
        if (kind === 'email_notifications') {
          data = {
            "kind": "in_app_notifications",
            "setting": Object.keys(this.checkedEmails)[0]
          }
        }
        if (kind !== 'in_app_notifications' && kind !== 'email_notifications') {
          data = {
            "kind": "email_updates",
            "setting": "task_assigned"
          }
        }
        this.checkedApps = []
        this.checkedEmails = []

        this.$store.dispatch('settings/updateNotificationsSettings', data)
          .then((response) => {
            console.log(response)
            this.toast('Success', `Setting is updated`)
          })
          .catch((error) => console.error(error))
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
    async mounted () {
      try {
        await this.$store.dispatch('settings/getNotificationsSettings')
          .then(response => console.log(response))
          .catch(error => console.error(error))
      } catch (error) {
        console.error(error)
      }
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
