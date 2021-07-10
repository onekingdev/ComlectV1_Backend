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
    makePrimaryPaymentMethod: jwt.makePrimaryPaymentMethod,
  },
}

// import Settings from "../../models/Settings";
import { SettingsGeneral, SettingsPaymentMethod } from "../../models/Settings";

export default {
  state: {
    settings: [],
    currentSetting: null,
    paymentMethods: []
  },
  mutations: {
    SET_SETTINGS(state, payload) {
      state.settings = payload
    },
    SET_CURRENT_SETTING (state, payload) {
      state.currentSettings = payload
    },
    SET_PAYMENT_METHODS (state, payload) {
      state.paymentMethods = payload
    },
    ADD_PAYMENT_METHOD (state, payload) {
      state.paymentMethods.push(payload)
    },
    UPDATE_PAYMENT_METHOD (state, payload) {
      const index = state.paymentMethods.findIndex(record => record.id === payload.id);
      state.paymentMethods.splice(index, 1, payload)
    },
    SET_ALL_PAYMENT_METHODS_NO_PRIMARY (state) {
      const updatedState = state.paymentMethods.map(record => ({ ...record, primary: false }));
      state.paymentMethods = updatedState
    },
    DELETE_PAYMENT_METHOD (state, payload) {
      const index = state.paymentMethods.findIndex(record => record.id === payload.id);
      state.paymentMethods.splice(index, 1)
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
              commit('ADD_PAYMENT_METHOD', new SettingsPaymentMethod(
                data.account_holder_name,
                data.account_holder_type,
                data.brand,
                data.country,
                data.coupon_id,
                data.currency,
                data.exp_month,
                data.exp_year,
                data.id,
                data.last4,
                data.payment_profile_id,
                data.primary,
                data.stripe_id,
                data.type,
                data.validated,
              ))
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
              const paymentMethods = []
              for (const item of data) {
                paymentMethods.push(new SettingsPaymentMethod(
                  item.account_holder_name,
                  item.account_holder_type,
                  item.brand,
                  item.country,
                  item.coupon_id,
                  item.currency,
                  item.exp_month,
                  item.exp_year,
                  item.id,
                  item.last4,
                  item.payment_profile_id,
                  item.primary,
                  item.stripe_id,
                  item.type,
                  item.validated,
                ))
              }
              commit('SET_PAYMENT_METHODS', paymentMethods)
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
    async deletePaymentMethod({state, commit, rootState}, payload) {
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
              commit('DELETE_PAYMENT_METHOD', { id: payload.id })
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
    async makePrimaryPaymentMethod({state, commit, rootState}, payload) {
      commit("clearError", null, {root: true});
      commit("setLoading", true, {root: true});
      try {
        const makePrimaryPaymentMethod = mapAuthProviders[rootState.shared.settings.authProvider].makePrimaryPaymentMethod
        const data = makePrimaryPaymentMethod(payload)
          .then((success) => {
            commit("clearError", null, {root: true});
            commit("setLoading", false, {root: true});
            if (success) {
              const data = success.data
              commit('SET_ALL_PAYMENT_METHODS_NO_PRIMARY')
              commit('UPDATE_PAYMENT_METHOD', new SettingsPaymentMethod(
                data.account_holder_name,
                data.account_holder_type,
                data.brand,
                data.country,
                data.coupon_id,
                data.currency,
                data.exp_month,
                data.exp_year,
                data.id,
                data.last4,
                data.payment_profile_id,
                data.primary,
                data.stripe_id,
                data.type,
                data.validated,
              ))
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
    currentSetting: state => state.currentSetting,
    paymentMethods: state => state.paymentMethods,
  },
};
