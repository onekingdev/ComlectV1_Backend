import Vue from 'vue'
import Vuex from 'vuex'

import tasks from "./specialistModules/tasks";
import settings from "./specialistModules/settings";
import projects from "./specialistModules/projects";
import stripeAccounts from "./specialistModules/stripe_accounts";

import auth from "./commonModules/auth";
import shared from "./commonModules/shared";
import roles from "./commonModules/roles-and-permissions";

Vue.use(Vuex)

const URL_MY_PROJECT_SHOW = '/specialist/my-projects/:id'
const URL_API_MY_PROJECT = '/api/specialist/projects/:id'
const URL_API_MY_PROJECTS = '/api/specialist/projects/my'
const URL_PROJECT_TIMESHEET = '/specialist/my-projects/:id/timesheets'
const URL_API_PROJECT_TIMESHEET = '/api/specialist/projects/:id/timesheets'

const URLS = {
  URL_MY_PROJECT_SHOW,
  URL_API_MY_PROJECT,
  URL_API_MY_PROJECTS,
  URL_PROJECT_TIMESHEET,
  URL_API_PROJECT_TIMESHEET,
}

const store = new Vuex.Store({
  getters: {
    url: () => (url, id) => URLS[url].replace(':id', id)
  },
  modules: {
    shared,
    auth,
    reminders: {
      namespaced: true,
      ...tasks,
    },
    settings: {
      namespaced: true,
      ...settings,
    },
    projects: {
      namespaced: true,
      ...projects,
    },
    roles: {
      namespaced: true,
      ...roles,
    },
    stripe_accounts: {
      namespaced: true,
      ...stripeAccounts
    }
  }
})

export default store
