import * as jwt from '@/services/business/marketplace'

const mapAuthProviders = {
  jwt: {
    getSpecialists: jwt.getSpecialists,
    createSpecialist: jwt.createSpecialist,
    updateSpecialist: jwt.updateSpecialist,
    deleteSpecialist: jwt.deleteSpecialist,
    getSpecialistById: jwt.getSpecialistById,
  },
}

import Specialist from "../../models/Specialist";

export default {
  state: {
    specialists: [],
    currentSpecialist: null,
  },
  mutations: {
    SET_SPECIALISTS(state, payload) {
      state.specialists = payload
    },
    SET_CURRENT_SPECIALIST (state, payload) {
      state.currentSpecialist = payload
    },
    ADD_SPECIALIST(state, payload) {
      state.specialists.push(payload)
    },
    UPDATE_SPECIALIST(state, payload) {
      const index = state.specialists.findIndex(record => record.id === payload.id);
      state.specialists.splice(index, 1, payload)
    },
    UPDATE_CURRENT_SPECIALIST(state, payload) {
      state.currentSpecialist = payload
    },
    DELETE_SPECIALIST(state, payload) {
      const index = state.specialists.findIndex(record => record.id === payload.id);
      state.specialists.splice(index, 1)
    },
  },
  actions: {
    async getSpecialists({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getSpecialists = mapAuthProviders[rootState.shared.settings.authProvider].getSpecialists
        const data = getSpecialists()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              const specialists = []
              for (const specialistItem of data) {
                specialists.push(new Specialist(
                  specialistItem.business_specialists_roles,
                  specialistItem.certifications,
                  specialistItem.experience,
                  specialistItem.first_name,
                  specialistItem.former_regulator,
                  specialistItem.id,
                  specialistItem.industries,
                  specialistItem.jurisdictions,
                  specialistItem.last_name,
                  specialistItem.location,
                  specialistItem.min_hourly_rate,
                  specialistItem.photo,
                  specialistItem.ratings_average,
                  specialistItem.ratings_count,
                  specialistItem.ratings_total,
                  specialistItem.resume_url,
                  specialistItem.seat_role,
                  specialistItem.skills,
                  specialistItem.time_zone,
                  specialistItem.username,
                  specialistItem.visibility,
                ))
              }
              commit('SET_SPECIALISTS', specialists)
              return data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)
        return data
      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
    },
    async createSpecialist({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const createSpecialist = mapAuthProviders[rootState.shared.settings.authProvider].createSpecialist
        createSpecialist(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('ADD_SPECIALIST', new Specialist(
                specialistItem.business_specialists_roles,
                specialistItem.certifications,
                specialistItem.experience,
                specialistItem.first_name,
                specialistItem.former_regulator,
                specialistItem.id,
                specialistItem.industries,
                specialistItem.jurisdictions,
                specialistItem.last_name,
                specialistItem.location,
                specialistItem.min_hourly_rate,
                specialistItem.photo,
                specialistItem.ratings_average,
                specialistItem.ratings_count,
                specialistItem.ratings_total,
                specialistItem.resume_url,
                specialistItem.seat_role,
                specialistItem.skills,
                specialistItem.time_zone,
                specialistItem.username,
                specialistItem.visibility,
              ))
              return success
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
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
    async updateSpecialist({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const updateSpecialist = mapAuthProviders[rootState.shared.settings.authProvider].updateSpecialist
        updateSpecialist(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('UPDATE_SPECIALIST', new Specialist(
                specialistItem.business_specialists_roles,
                specialistItem.certifications,
                specialistItem.experience,
                specialistItem.first_name,
                specialistItem.former_regulator,
                specialistItem.id,
                specialistItem.industries,
                specialistItem.jurisdictions,
                specialistItem.last_name,
                specialistItem.location,
                specialistItem.min_hourly_rate,
                specialistItem.photo,
                specialistItem.ratings_average,
                specialistItem.ratings_count,
                specialistItem.ratings_total,
                specialistItem.resume_url,
                specialistItem.seat_role,
                specialistItem.skills,
                specialistItem.time_zone,
                specialistItem.username,
                specialistItem.visibility,
              ))
              commit('UPDATE_CURRENT_SPECIALIST', new Specialist(
                specialistItem.business_specialists_roles,
                specialistItem.certifications,
                specialistItem.experience,
                specialistItem.first_name,
                specialistItem.former_regulator,
                specialistItem.id,
                specialistItem.industries,
                specialistItem.jurisdictions,
                specialistItem.last_name,
                specialistItem.location,
                specialistItem.min_hourly_rate,
                specialistItem.photo,
                specialistItem.ratings_average,
                specialistItem.ratings_count,
                specialistItem.ratings_total,
                specialistItem.resume_url,
                specialistItem.seat_role,
                specialistItem.skills,
                specialistItem.time_zone,
                specialistItem.username,
                specialistItem.visibility,
              ))
              return success
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
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
    async deleteSpecialist({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const deleteSpecialist = mapAuthProviders[rootState.shared.settings.authProvider].deleteSpecialist
        deleteSpecialist(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('DELETE_SPECIALIST', new Specialist(
                specialistItem.business_specialists_roles,
                specialistItem.certifications,
                specialistItem.experience,
                specialistItem.first_name,
                specialistItem.former_regulator,
                specialistItem.id,
                specialistItem.industries,
                specialistItem.jurisdictions,
                specialistItem.last_name,
                specialistItem.location,
                specialistItem.min_hourly_rate,
                specialistItem.photo,
                specialistItem.ratings_average,
                specialistItem.ratings_count,
                specialistItem.ratings_total,
                specialistItem.resume_url,
                specialistItem.seat_role,
                specialistItem.skills,
                specialistItem.time_zone,
                specialistItem.username,
                specialistItem.visibility,
              ))
              return success
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
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
    async getSpecialistsById({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const getSpecialistsById = mapAuthProviders[rootState.shared.settings.authProvider].getSpecialistsById
        getSpecialistsById(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              commit('SET_CURRENT_SPECIALIST', new Specialist(
                specialistItem.business_specialists_roles,
                specialistItem.certifications,
                specialistItem.experience,
                specialistItem.first_name,
                specialistItem.former_regulator,
                specialistItem.id,
                specialistItem.industries,
                specialistItem.jurisdictions,
                specialistItem.last_name,
                specialistItem.location,
                specialistItem.min_hourly_rate,
                specialistItem.photo,
                specialistItem.ratings_average,
                specialistItem.ratings_count,
                specialistItem.ratings_total,
                specialistItem.resume_url,
                specialistItem.seat_role,
                specialistItem.skills,
                specialistItem.time_zone,
                specialistItem.username,
                specialistItem.visibility,
              ))
              return success
            }
            if (!success) {
              console.error('Not success', success)
            }
          })
          .catch(error => error)
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
  },
  getters: {
    specialists: state => state.specialists,
    currentSpecialist: state => state.currentSpecialist
  },
};
