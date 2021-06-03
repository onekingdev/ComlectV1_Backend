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
              const exams = []
              for (const examItem of data) {
                exams.push(new Specialist(
                  examItem.complete,
                  examItem.created_at,
                  examItem.ends_on,
                  examItem.exam_requests,
                  examItem.id,
                  examItem.name,
                  examItem.share_uuid,
                  examItem.starts_on,
                  examItem.updated_at,
                ))
              }
              commit('SET_SPECIALISTS', exams)
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
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
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
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
              ))
              commit('UPDATE_CURRENT_SPECIALIST', new Specialist(
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
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
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
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
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
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
