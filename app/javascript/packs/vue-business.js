import init from './vue/init'
import store from '@/store/business'
import router from '@/router'

import MainLayoyt from './vue/layouts/Main'
import BuilderLayoyt from './vue/layouts/Builder'

init({
  store,
  router,
  components: {
    MainLayoyt,
    BuilderLayoyt,
  }
})
