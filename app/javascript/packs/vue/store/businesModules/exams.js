import * as jwt from '@/services/business/exams'

const mapAuthProviders = {
  jwt: {
    getExams: jwt.getExams,
    createExam: jwt.createExam,
    getExam: jwt.getExam,
    updateExam: jwt.updateExam,
    deleteExam: jwt.deleteExam,
  },
}

import ExamManagement from "../../models/ExamManagement";

export default {
  state: {
    exams: [],
    currentExam: null,
  },
  mutations: {
    SET_EXAMS(state, payload) {
      state.exams = payload
    },
    SET_CURRENT_EXAM (state, payload) {
      state.currentExam = payload
    },
    ADD_EXAM(state, payload) {
      state.exams.push(payload)
    },
    UPDATE_EXAM(state, payload) {
      const index = state.exams.findIndex(record => record.id === payload.id);
      state.exams.splice(index, 1, payload)
    },
    DELETE_EXAM(state, payload) {
      const index = state.exams.findIndex(record => record.id === payload.id);
      state.exams.splice(index, 1)
    },
  },
  actions: {
    async getExams({state, commit, rootState}, payload) {
      try {
        commit("clearError", null, {
          root: true
        });
        commit("setLoading", true, {
          root: true
        });

        const getExams = mapAuthProviders[rootState.shared.settings.authProvider].getExams
        getExams()
          .then((success) => {
            if (success) {

              const data = success.data
              const exams = []
              // console.log(data)
              for (const examItem of data) {
                exams.push(new ExamManagement(
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
              commit('SET_EXAMS', exams)
              return success
            }
            if (!success) {
              // console.log('Not success', success)
            }
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
          })


      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false, {
          root: true
        });
      }
    },
    async createExam({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const createExam = mapAuthProviders[rootState.shared.settings.authProvider].createExam
        createExam(payload)
          .then((success) => {
            if (success) {
              const data = success.data
              commit('ADD_EXAM', new ExamManagement(
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
              // console.log('Not success', success)
            }
            commit("clearError");
            commit("setLoading", false);
          })
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      } finally {
        commit("setLoading", false, {
          root: true
        })
      }
    },
    async getExam({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const getExam = mapAuthProviders[rootState.shared.settings.authProvider].getExam
        getExam(payload)
          .then((success) => {
            if (success) {
              const data = success.data
              commit('SET_CURRENT_EXAM', new ExamManagement(
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
              // console.log('Not success', success)
            }
            commit("clearError");
            commit("setLoading", false);
          })
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      } finally {
        commit("setLoading", false, {
          root: true
        })
      }
    },
    async updateExam({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const updateExam = mapAuthProviders[rootState.shared.settings.authProvider].updateExam
        updateExam(payload)
          .then((success) => {
            if (success) {
              const data = success.data
              commit('UPDATE_EXAM', new ExamManagement(
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
              // console.log('Not success', success)
            }
            commit("clearError");
            commit("setLoading", false);
          })
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      } finally {
        commit("setLoading", false, {
          root: true
        })
      }
    },
    async deleteExam({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const deleteExam = mapAuthProviders[rootState.shared.settings.authProvider].deleteExam
        deleteExam(payload)
          .then((success) => {
            if (success) {
              const data = success.data
              commit('DELETE_EXAM', new ExamManagement(
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
              // console.log('Not success', success)
            }
            commit("clearError");
            commit("setLoading", false);
          })
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      } finally {
        commit("setLoading", false, {
          root: true
        })
      }
    },
  },
  getters: {
    exams: state => state.exams,
    currentExam: state => state.currentExam
  },
};
