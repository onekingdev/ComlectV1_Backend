import Vue from "vue";
import Vuex from "vuex";

import shared from "./commonModules/shared";
import auth from "./commonModules/auth";

// FOR PORTALS
import exams from "./businesModules/exams"

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    shared,
    auth,
    exams: {
      namespaced: true,
      ...exams,
    },
  },
});

console.log('store', store)

export default store;
