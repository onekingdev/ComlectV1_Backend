import axios from 'axios'

const instance = axios.create({
  baseURL: '/api',
  timeout: 1000,
  headers: {'X-Custom-Header': 'foobar'}
});

export default {
  state: {
    specialists: [],
  },
  mutations: {
    updateSpecialistsList(state, payload) {
      state.specialists = payload;
    },
  },
  actions: {
    async getSpecialists ({commit}) {
      commit("clearError");
      commit("setLoading", true);

      instance.get('/business/specialists')
        .then(function (response) {
          // handle success
          commit('updateSpecialistsList', response.data)
        })
        .catch(function (error) {
          // handle error
          console.log(error);
          throw error
        })
        .then(function () {
          // always executed
          commit("setLoading", false)
        });

    },
  },
  getters: {
    specialistsList(state) {
      return state.specialists;
    },
  },
};
