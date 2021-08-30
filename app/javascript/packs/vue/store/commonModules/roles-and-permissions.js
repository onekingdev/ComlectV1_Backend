import * as jwt from '@/services/common/roles-and-permissions'

// import { RolesAndPermissions } from "../../models/RolesAndPermissions";

const plan = localStorage.getItem('app.currentUser.plan') ? localStorage.getItem('app.currentUser.plan') : ''
const role = localStorage.getItem('app.currentUser.role') ? localStorage.getItem('app.currentUser.role') : ''
const businessIDLocalStorage = localStorage.getItem('app.business_id') ? localStorage.getItem('app.business_id') : ''

const mapAuthProviders = {
  jwt: {
    getRoles: jwt.getRoles,
    getCurrentAccount: jwt.getCurrentAccount
  },
}

export default {
  state: {
    currentPlan: plan,
    roles: [],
    currentRole: role,
    businessID: null,
    currentAccount: businessIDLocalStorage,
  },
  mutations: {
    SET_ROLES (state, payload) {
      state.roles = payload
    },
    SET_CURRENT_ROLE (state, payload) {
      state.currentRole = payload
    },
    SET_BUSINESS_ID (state, payload) {
      state.businessID = payload
    },
    SET_CURRENT_ACCOUNT (state, payload) {
      state.currentAccount = payload
    },
    SET_CURRENT_PLAN (state, payload) {
      state.currentPlan = payload
    }
  },
  actions: {
    async getRoles({state, commit, rootState}) {
      // commit("clearError", null, { root: true });
      // commit("setLoading", true, { root: true });
      try {
        const getRoles = mapAuthProviders[rootState.shared.settings.authProvider].getRoles
        const data = getRoles()
          .then((success) => {
            // commit("clearError", null, { root: true });
            // commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data

              if(Array.isArray(data)) {
                commit('SET_ROLES', data)

                if (data[0]) {
                  const businessID = data[0].business_id
                  commit('SET_BUSINESS_ID', businessID)
                  // window.localStorage["app.business_id"] = JSON.stringify(businessID)
                  if (data[0].role) {
                    commit('SET_CURRENT_ROLE', data[0].role)
                    localStorage.setItem('app.currentUser.role', data[0].role)
                  }
                  if (data[0].plan) {
                    commit('SET_CURRENT_PLAN', data[0].plan)
                    localStorage.setItem('app.currentUser.plan', data[0].plan)
                  }
                } else {
                  //ommit('SET_BUSINESS_ID', '')
                  //localStorage.removeItem('app.business_id')
                }
              }
              return data
            }
            if (!success) {
              console.error('Not success', success)
              // commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)

        return data;

      } catch (error) {
        console.error('catch error', error);
        // commit("setError", error.message, { root: true });
        // commit("setLoading", false, { root: true });
        throw error
      }
    },
    async getCurrentAccount({state, commit, rootState}, payload) {
      // commit("clearError", null, { root: true });
      // commit("setLoading", true, { root: true });
      try {
        const getCurrentAccount = mapAuthProviders[rootState.shared.settings.authProvider].getCurrentAccount
        const data = getCurrentAccount(payload)
          .then((success) => {
            // commit("clearError", null, { root: true });
            // commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              commit('SET_CURRENT_ACCOUNT', data)
              if (data.plan && !state.plan) {
                commit('SET_CURRENT_PLAN', data.plan)
                localStorage.setItem('app.currentUser.plan', data.plan)
              }
              return data
            }
            if (!success) {
              console.error('Not success', success)
              // commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)

        return data;

      } catch (error) {
        console.error('catch error', error);
        // commit("setError", error.message, { root: true });
        // commit("setLoading", false, { root: true });
        throw error
      }
    },
  },
  getters: {
    roles (state) {
      return state.roles
    },
    currentRole (state) {
      return state.currentRole
    },
    businessID (state) {
      return state.businessID
    },
    currentAccount (state) {
      return state.currentAccount
    },
    currentPlan (state) {
      return state.currentPlan
    },
  },
};
