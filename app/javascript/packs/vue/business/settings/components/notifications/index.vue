<template lang="pug">
  div
    .row(v-if='loading')
      .col
        .card-body.white-card-body.px-3.px-xl-5
          .settings___card--internal.p-y-1
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
                      .col-10
                        h4
                          b Tasks
                      .col.text-center IN-APP
                      .col.text-center EMAIL
                    .row
                      .col-10
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in notificationsTasksOptions" :key="'task-main-'+i")
                          label {{option.label}}
                      .col.text-center
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in notifications.in_app_notifications.tasks" :key="'task-app-'+i" )
                          input.mb-2(type="checkbox" v-model="checkedApps[i]" :value="Object.keys(option)[0]" class="regular-checkbox" @change="onChange('in_app_notifications', Object.keys(option)[0])")
                      .col.text-center
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in notifications.email_notifications.tasks" :key="'task-email-'+i" )
                          input.mb-2(type="checkbox" v-model="checkedEmails[i]" :value="Object.keys(option)[0]" class="regular-checkbox" @change="onChange('email_notifications', Object.keys(option)[0])")
                    .row.m-t-1
                      .col-12
                        h4
                          b Projects
                    .row.mb-2
                      .col-10
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in notificationsProjectsOptions" :key="'project'+i")
                          label {{option.label}}
                      .col.text-center
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in notifications.in_app_notifications.projects" :key="'projects-app-'+i" )
                          input(type="checkbox" v-model="checkedApps[i]" :value="Object.keys(option)[0]" class="regular-checkbox" @change="onChange('in_app_notifications', Object.keys(option)[0])")
                      .col.text-center
                        .custom-checkbox.b-custom-control-lg.pl-0(v-for="(option, i) in notifications.email_notifications.projects" :key="'projects-email-'+i" )
                          input(type="checkbox" v-model="checkedEmails[i]" :value="Object.keys(option)[0]" class="regular-checkbox" @change="onChange('in_app_notifications', Object.keys(option)[0])")
                    .row.m-t-1
                      .col-12
                        h4
                          b Email Updates
                      .col-md-6
                        b-form-group
                          b-form-checkbox(v-for="(option, i) in notificationsEmailOptions" :key="'email'+i" v-model="checkedEmailsUpdates[i]" :value="option.value" size="lg" @change="onChange('email_updates', option.value)") {{option.label}}
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
    { label: 'When a task is completed' },
    { label: 'When a task is overdue' },
  ]

  const NOTIFICATIONS_PROJECTS_OPTIONS = [
    { label: 'When new applicants bid for a project' },
    { label: 'When applicants message me' },
    { label: 'When a specialist accepts a project completition' },
    { label: 'When a specialist accepts a dedline extension' },
  ]

  const NOTIFICATIONS_EMAIL_OPTIONS = [
    { label: 'Monthly Compilance Newsletter', value: 'monthly_newsletter' },
    { label: 'Promos and Upcomming Events', value: 'promos_and_events' },
  ]

  const initialForm = () => ({
    in_app_notifications: {
      task_created: true,
      task_assigned: true,
      task_file_uploaded: true,
      task_new_comment: true,
      task_completed: true,
      task_overdue: true,
      project_new_bid: true,
      project_message: true,
      project_overdue: true,
      project_ended: true,
      project_completed: true,
      got_rated: true,
      got_message: true,
      new_forum_answers: true,
      new_forum_comments: true,
    },
    email_notifications: {
      task_created: true,
      task_assigned: true,
      task_file_uploaded: true,
      task_new_comment: true,
      task_completed: true,
      task_overdue: true,
      project_new_bid: true,
      project_message: true,
      project_overdue: true,
      project_ended: true,
      project_completed: true,
      got_rated: true,
      got_message: true,
      new_forum_question: true,
      new_forum_comments: true
    },
    email_updates: {
      monthly_newsletter: true,
      promos_and_events: true
    }
  })

  const prepareCheckboxes = (form) => {
    const tasksApp = []
    const projectsApp = []
    const tasksEmails = []
    const projectsEmails = []
    const email_updates = []
    for(const [key, value] of Object.entries(form)) {
      if (key === 'in_app_notifications') {
        for(const [keyIn, valueIn] of Object.entries(value)) {
          const splitedKey = keyIn.split('_')[0]
          if (splitedKey === 'task') tasksApp.push({[keyIn]: valueIn})
          if (splitedKey === 'project') projectsApp.push({[keyIn]: valueIn})
        }
      }
      if (key === 'email_notifications') {
        for(const [keyIn, valueIn] of Object.entries(value)) {
          const splitedKey = keyIn.split('_')[0]
          if (splitedKey === 'task') tasksEmails.push({[keyIn]: valueIn})
          if (splitedKey === 'project') projectsEmails.push({[keyIn]: valueIn})
        }
      }
      if (key !== 'in_app_notifications' && key !== 'email_notifications') {
        for(const [keyIn, valueIn] of Object.entries(value)) {
          email_updates.push({[keyIn]: valueIn})
        }
      }
    }
    return {
      in_app_notifications: {tasks: tasksApp, projects: projectsApp },
      email_notifications: {tasks: tasksEmails, projects: projectsEmails },
      email_updates
    }
  }

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
        checkedEmails: [],
        checkedEmailsUpdates: []
      };
    },
    methods: {
      onChange (kind, setting) {
        console.log(kind, setting)
        const data = {
          "kind": kind,
          "setting": setting
        }

        this.$store.dispatch('settings/updateNotificationsSettings', data)
          .then((response) => {
            if (response.error) {
              this.toast('Error', `${response.error}`)
            }
            if (!response.error) {
              console.log(response)
              this.toast('Success', `Setting is updated`)
            }
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
      notifications() {
        return prepareCheckboxes(this.form)
      },
      notificationsTasksEmails() {
        const tasks = []
        for(const [key, value] of Object.entries(this.form)) {
          if (key === 'email_notifications') {
            for(const [keyIn, valueIn] of Object.entries(value)) {
              const splitedKey = keyIn.split('_')[0]
              if (splitedKey === 'task') tasks.push({[keyIn]: valueIn})
            }
          }
        }
        return tasks
      }
    },
    async mounted () {
      try {
        await this.$store.dispatch('settings/getNotificationsSettings')
          .then(response => {
            console.log(response)
            for(const [key, value] of Object.entries(response)) {
              if (key === 'in_app_notifications') {
                for(const [keyIn, valueIn] of Object.entries(value)) {
                  if (valueIn) this.checkedApps.push(keyIn)
                  else this.checkedApps.push(null)
                }
              }
              if (key === 'email_notifications') {
                for(const [keyIn, valueIn] of Object.entries(value)) {
                  if (valueIn) this.checkedEmails.push(keyIn)
                  else this.checkedEmails.push(null)
                }
              }
              if (key !== 'in_app_notifications' && key !== 'email_notifications') {
                for(const [keyIn, valueIn] of Object.entries(value)) {
                  if (valueIn) this.checkedEmailsUpdates.push(keyIn)
                  else this.checkedEmailsUpdates.push(null)
                }
              }
            }
          })
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
    /*width: 20px;*/
    /*height: 20px;*/
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
