const userTypeLocalStorage = localStorage.getItem('app.currentUser.userType') ? localStorage.getItem('app.currentUser.userType') : ''

export default {
  state: {
    loading: false,
    error: null,
    settings: {
      authProvider: 'jwt',
    },
    leftSidebar: 'default',
    userType: userTypeLocalStorage ? JSON.parse(userTypeLocalStorage) : '',
    overlay: {
      active: false,
      message: '',
      status: ''
    }
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
    },
    changeUserType (state, payload) {
      state.userType = payload
    },
    changeOverlay (state, payload) {
      state.overlay = payload
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
    },
    setOverlay ({commit}, payload) {
      commit('changeOverlay', payload)
    },
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
    },
    userType (state) {
      return state.userType
    },
    overlay (state) {
      return state.overlay
    },
  }
}
