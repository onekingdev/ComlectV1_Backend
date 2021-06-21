export default {
  state: {
    loading: false,
    error: null,
    settings: {
      authProvider: 'jwt',
    },
    leftSidebar: 'default'
  },
  mutations: {
    setLoading (state, payload) {
      state.loading = payload
    },
    setError (state, payload) {
      state.error = payload
    },
    clearError (state) {
      state.error = null
    },
    changeSidebar (state, payload) {
      state.leftSidebar = payload
    }
  },
  actions: {
    setLoading ({commit}, payload) {
      commit('setLoading', payload)
    },
    setError ({commit}, payload) {
      commit('setError', payload)
    },
    clearError ({commit}) {
      commit('clearError')
    }
  },
  getters: {
    loading (state) {
      return state.loading
    },
    error (state) {
      return state.error
    },
    settings (state) {
      return state.settings
    },
    leftSidebar (state) {
      return state.leftSidebar
    }
  }
}
