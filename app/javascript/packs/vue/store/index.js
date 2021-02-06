import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const URL_PROJECT_SHOW = '/business/projects/:id/'
const URLS = {
  URL_PROJECT_SHOW
}

const store = new Vuex.Store({
  getters: {
    url: () => (url, id) => URLS[url].replace(':id', id)
  }
})

export default store