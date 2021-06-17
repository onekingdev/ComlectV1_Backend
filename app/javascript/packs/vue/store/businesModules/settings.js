import * as jwt from '@/services/common/settings'

const mapAuthProviders = {
  jwt: {
    getGeneralSettings: jwt.getGeneralSettings,
    updateGeneralSettings: jwt.updateGeneralSettings,
    updatePasswordSettings: jwt.updatePasswordSettings,
    deleteAccount: jwt.deleteAccount,
    getNotificationsSettings: jwt.getNotificationsSettings,
    updateNotificationsSettings: jwt.updateNotificationsSettings,
    updateSubscribe: jwt.updateSubscribe,
    updateSeatsSubscribe: jwt.updateSeatsSubscribe,
    generatePaymentMethod: jwt.generatePaymentMethod,
    getPaymentMethod: jwt.getPaymentMethod,
    deletePaymentMethod: jwt.deletePaymentMethod,
  },
}

// import Settings from "../../models/Settings";
import { SettingsGeneral } from "../../models/Settings";
import axios from "../../services/axios";

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
      state.currentSettings = payload
    },
  },
  actions: {
    async getGeneralSettings({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getGeneralSettings = mapAuthProviders[rootState.shared.settings.authProvider].getGeneralSettings
        const data = getGeneralSettings()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              // const settings = []
              // for (const settingItem of data) {
              //   settings.push(new SettingsGeneral(
              //     settingItem.apartment,
              //     settingItem.city,
              //     settingItem.contact_phone,
              //     settingItem.country,
              //     settingItem.state,
              //     settingItem.time_zone
              //   ))
              // }
              const settings = new SettingsGeneral(
                data.city,
                data.contact_phone,
                data.country,
                data.state,
                data.time_zone
              )
              commit('SET_SETTINGS', { general: settings })
              return success.data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)

        return data;

      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
    },
    async updateGeneralSettings({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const updateGeneralSettings = mapAuthProviders[rootState.shared.settings.authProvider].updateGeneralSettings
        const data = updateGeneralSettings(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              return data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
        return data
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
    },
    async updatePasswordSettings({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const updatePasswordSettings = mapAuthProviders[rootState.shared.settings.authProvider].updatePasswordSettings
        const data = updatePasswordSettings(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              return data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
        return data
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
    },
    async deleteAccount({state, commit, rootState}) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const deleteAccount = mapAuthProviders[rootState.shared.settings.authProvider].deleteAccount
        const data = deleteAccount()
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              return data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
        return data
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
    },
    async getNotificationsSettings({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getNotificationsSettings = mapAuthProviders[rootState.shared.settings.authProvider].getNotificationsSettings
        const data = getNotificationsSettings()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              // const settings = []
              // for (const settingItem of data) {
              //   settings.push(new SettingsGeneral(
              //     settingItem.apartment,
              //     settingItem.city,
              //     settingItem.contact_phone,
              //     settingItem.country,
              //     settingItem.state,
              //     settingItem.time_zone
              //   ))
              // }
              const settings = new SettingsGeneral(
                data.city,
                data.contact_phone,
                data.country,
                data.state,
                data.time_zone
              )
              commit('SET_SETTINGS', { general: settings })
              return success.data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)

        return data;

      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
    },
    async updateNotificationsSettings({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const updateNotificationsSettings = mapAuthProviders[rootState.shared.settings.authProvider].updateNotificationsSettings
        const data = updateNotificationsSettings(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              return data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)

        return data;

      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
    },
    async updateSubscribe({state, commit, rootState}, payload) {
      commit("clearError", null, {root: true});
      commit("setLoading", true, {root: true});
      try {
        const updateSubscribe = mapAuthProviders[rootState.shared.settings.authProvider].updateSubscribe
        const data = updateSubscribe(payload)
          .then((success) => {
            commit("clearError", null, {root: true});
            commit("setLoading", false, {root: true});
            if (success) {
              const data = success.data
              return data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, {root: true});
            }
          })
          .catch(error => error)
        return data;
      } catch (error) {
        console.error(error);
      }
    },
    async updateSeatsSubscribe({state, commit, rootState}, payload) {
      commit("clearError", null, {root: true});
      commit("setLoading", true, {root: true});
      try {
        const updateSeatsSubscribe = mapAuthProviders[rootState.shared.settings.authProvider].updateSeatsSubscribe
        const data = updateSeatsSubscribe(payload)
          .then((success) => {
            commit("clearError", null, {root: true});
            commit("setLoading", false, {root: true});
            if (success) {
              const data = success.data
              return data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, {root: true});
            }
          })
          .catch(error => error)
        return data;
      } catch (error) {
        console.error(error);
      }
    },
    async generatePaymentMethod({state, commit, rootState}, payload) {
      commit("clearError", null, {root: true});
      commit("setLoading", true, {root: true});
      try {
        const generatePaymentMethod = mapAuthProviders[rootState.shared.settings.authProvider].generatePaymentMethod
        const data = generatePaymentMethod(payload)
          .then((success) => {
            commit("clearError", null, {root: true});
            commit("setLoading", false, {root: true});
            if (success) {
              const data = success.data
              return data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, {root: true});
            }
          })
          .catch(error => error)
        return data;
      } catch (error) {
        console.error(error);
      }
    },
    async getPaymentMethod({state, commit, rootState}, payload) {
      commit("clearError", null, {root: true});
      commit("setLoading", true, {root: true});
      try {
          const getPaymentMethod = mapAuthProviders[rootState.shared.settings.authProvider].getPaymentMethod
          const data = getPaymentMethod(payload)
            .then((success) => {
              commit("clearError", null, {root: true});
              commit("setLoading", false, {root: true});
              if (success) {
                const data = success.data
                return data
              }
              if (!success) {
                console.error('Not success', success)
                commit("setError", success.message, {root: true});
              }
            })
            .catch(error => error)
          return data;
        } catch (error) {
          console.error(error);
        }
    },
    async deletePaymentMethod({commit, getters}, payload) {
      commit("clearError", null, {root: true});
      commit("setLoading", true, {root: true});
      try {
        const deletePaymentMethod = mapAuthProviders[rootState.shared.settings.authProvider].deletePaymentMethod
        const data = deletePaymentMethod(payload)
          .then((success) => {
            commit("clearError", null, {root: true});
            commit("setLoading", false, {root: true});
            if (success) {
              const data = success.data
              return data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, {root: true});
            }
          })
          .catch(error => error)
        return data;
      } catch (error) {
        console.error(error);
      }
    },
  },
  getters: {
    settings: state => state.settings,
    currentSetting: state => state.currentSetting
  },
};
