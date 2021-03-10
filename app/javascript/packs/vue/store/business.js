import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const URL_PROJECT_SHOW = '/business/projects/:id'
const URL_PROJECT_APPLICATIONS = `${URL_PROJECT_SHOW}/applications`
const URL_PROJECT_POST = `/business/project_posts/:id`
const URL_API_PROJECT_APPLICATIONS = `/api${URL_PROJECT_APPLICATIONS}`
const URL_API_PROJECT_HIRES = `/api${URL_PROJECT_SHOW}/hires`
const URL_POST_LOCAL_PROJECT = '/business/projects/new?local_project_id=:id'
const URL_PROJECT_TIMESHEETS = `${URL_PROJECT_SHOW}/timesheets`
const URL_API_PROJECT_TIMESHEETS = `/api${URL_PROJECT_TIMESHEETS}`

const URLS = {
  URL_PROJECT_SHOW,
  URL_PROJECT_APPLICATIONS,
  URL_PROJECT_POST,
  URL_API_PROJECT_APPLICATIONS,
  URL_API_PROJECT_HIRES,
  URL_POST_LOCAL_PROJECT,
  URL_PROJECT_TIMESHEETS,
  URL_API_PROJECT_TIMESHEETS,
}

const store = new Vuex.Store({
  getters: {
    url: () => (url, id) => URLS[url].replace(':id', id)
  }
})

export default store