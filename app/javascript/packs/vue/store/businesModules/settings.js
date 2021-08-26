import * as jwt from '@/services/common/settings'
import * as jwtEmployee from '@/services/business/employee'

const mapAuthProviders = {
  jwt: {
    getGeneralSettings: jwt.getGeneralSettings,
    updateGeneralSettings: jwt.updateGeneralSettings,
    resetEmailSettings: jwt.resetEmailSettings,
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
    getEmployees: jwtEmployee.getEmployees,
    getEmployeesSpecialists: jwtEmployee.getEmployeesSpecialists,
    createEmployee: jwtEmployee.createEmployee,
    updateEmployee: jwtEmployee.updateEmployee,
    disableEmployee: jwtEmployee.disableEmployee,
    deleteEmployee: jwtEmployee.deleteEmployee,
    getStaticCollection: jwt.getStaticCollection,
    getAvailableSeatsCount: jwtEmployee.getAvailableSeatsCount,
  },
}

// import Settings from "../../models/Settings";
import { SettingsGeneral, SettingsPaymentMethod } from "../../models/Settings";

export default {
  state: {
    settings: [],
    currentSetting: null,
    paymentMethods: [],
    employees: [],
    employeesSpecialists: [],
    staticCollection: {
      GOOGLE_PLACES_API_KEY: '',
      PLAID_PUBLIC_KEY: '',
      STRIPE_PUBLISHABLE_KEY: '',
      countries: [],
      industries: [],
      jurisdictions: [],
      states: [],
      sub_industries_business: [],
      sub_industries_specialist: [],
      timezones: [],
    },
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
    SET_EMPLOYEES(state, payload) {
      state.employees = payload
    },
    ADD_EMPLOYEES (state, payload) {
      state.employees.push(payload)
    },
    UPDATE_EMPLOYEES (state, payload) {
      const index = state.employees.findIndex(record => record.id === payload.id);
      state.employees.splice(index, 1, payload)
    },
    DELETE_EMPLOYEES (state, payload) {
      const index = state.employees.findIndex(record => record.id === payload.id);
      state.employees.splice(index, 1)
    },
    SET_STATIC_COLLECTION (state, payload) {
      const timezones = payload.timezones.map(tz => {
          const [ zone, city ] = tz
          return {
            value: city,
            name: zone
          }
        }
      )
      state.staticCollection = {
        ...payload,
        timezones
      }
    },
    SET_EMPLOYEES_SPECIALISTS(state, payload) {
      state.employees = payload
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
    async resetEmailSettings({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const resetEmailSettings = mapAuthProviders[rootState.shared.settings.authProvider].resetEmailSettings
        const data = resetEmailSettings(payload)
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
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const updatePasswordSettings = mapAuthProviders[rootState.shared.settings.authProvider].updatePasswordSettings
        const data = updatePasswordSettings(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
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
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
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
    async getEmployees({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getEmployees = mapAuthProviders[rootState.shared.settings.authProvider].getEmployees
        const data = getEmployees()
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
              commit('SET_EMPLOYEES', data)
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
    async createEmployee({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const createEmployee = mapAuthProviders[rootState.shared.settings.authProvider].createEmployee
        const data = createEmployee(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            // if(success.status !== 200 || success.status !== 201) throw new Error(`${success.status} ${success.statusText}`)
            if (success) {
              const data = success.data
              if (!data.errors) commit('ADD_EMPLOYEES', data)
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
    async updateEmployee({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const updateEmployee = mapAuthProviders[rootState.shared.settings.authProvider].updateEmployee
        const data = updateEmployee(payload)
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
              commit('UPDATE_EMPLOYEES', data)
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
    async disableEmployee({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const updateEmployee = mapAuthProviders[rootState.shared.settings.authProvider].updateEmployee
        const data = updateEmployee(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              if (!data.errors) commit('UPDATE_EMPLOYEES', data)
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
    async deleteEmployee({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const deleteEmployee = mapAuthProviders[rootState.shared.settings.authProvider].deleteEmployee
        const data = deleteEmployee(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              commit('DELETE_EMPLOYEES', data)
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
    async getStaticCollection({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getStaticCollection = mapAuthProviders[rootState.shared.settings.authProvider].getStaticCollection
        const data = getStaticCollection()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              commit('SET_STATIC_COLLECTION', data)
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
    async getEmployeesSpecialists({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getEmployeesSpecialists = mapAuthProviders[rootState.shared.settings.authProvider].getEmployeesSpecialists
        const data = getEmployeesSpecialists()
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
              commit('SET_EMPLOYEES_SPECIALISTS', data)
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
    async getAvailableSeatsCount({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getAvailableSeatsCount = mapAuthProviders[rootState.shared.settings.authProvider].getAvailableSeatsCount
        const data = getAvailableSeatsCount()
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
    currentSetting: state => state.currentSetting,
    paymentMethods: state => state.paymentMethods,
    employees: state => state.employees,
    employeesSpecialists: state => state.employeesSpecialists,
    staticCollection(state) {
      return state.staticCollection
    },
  },
};
