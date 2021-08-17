import Vue from 'vue'
import Vuex from 'vuex'

import tasks from "./specialistModules/tasks"
import settings from "./specialistModules/settings";
import projects from "./specialistModules/projects"
import shared from "./commonModules/shared";
import auth from "./commonModules/auth";

Vue.use(Vuex)

const URL_MY_PROJECT_SHOW = '/specialist/my-projects/:id'
const URL_API_MY_PROJECT = '/api/specialist/projects/:id'
const URL_API_MY_PROJECTS = '/api/specialist/projects/my'
const URL_PROJECT_TIMESHEET = '/projects/:id/timesheets'
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
  }
})

export default store
