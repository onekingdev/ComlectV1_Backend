import * as jwt from '@/services/business/settings'

const mapAuthProviders = {
  jwt: {
    getSettings: jwt.getSettings,
  },
}

import Settings from "../../models/Settings";

export default {
  state: {
    settings: [],
    currentSetting: null,
  },
  mutations: {
    SET_SETTINGS(state, payload) {
      state.settings = payload
    },
    SET_CURRENT_SETTING (state, payload) {
      state.currentExam = payload
    },
  },
  actions: {
    async getSettings({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getSettings = mapAuthProviders[rootState.shared.settings.authProvider].getSettings
        getSettings()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              const settings = []
              for (const settingItem of data) {
                settings.push(new Settings(
                  // settingItem.complete,
                ))
              }
              commit('SET_SETTINGS', settings)
              return success
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)
      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
    },
  },
  getters: {
    settings: state => state.settings,
    currentSetting: state => state.currentSetting
  },
};
