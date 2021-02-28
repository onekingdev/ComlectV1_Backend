import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const URL_MY_PROJECTS = '/api/specialist/projects/my'

const URLS = {
  URL_MY_PROJECTS,
}

const store = new Vuex.Store({
  getters: {
    url: () => (url, id) => URLS[url].replace(':id', id)
  }
})

export default store