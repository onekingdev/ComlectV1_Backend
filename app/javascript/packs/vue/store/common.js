import Vue from "vue";
import Vuex from "vuex";

import shared from "./commonModules/shared";
import auth from "./commonModules/auth";

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    shared,
    auth,
  },
});

export default store;
