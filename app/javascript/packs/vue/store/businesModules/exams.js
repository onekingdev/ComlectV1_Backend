import * as jwt from '@/services/business/exams'

const mapAuthProviders = {
  jwt: {
    getExams: jwt.getExams,
    createExam: jwt.createExam,
    updateExam: jwt.updateExam,
    deleteExam: jwt.deleteExam,
    getExamById: jwt.getExamById,
    createExamRequest: jwt.createExamRequest,
    deleteExamRequest: jwt.deleteExamRequest,
    updateExamRequest: jwt.updateExamRequest,
    uploadExamRequestFile: jwt.uploadExamRequestFile,
    deleteExamRequestFile: jwt.deleteExamRequestFile,
  },
}

import ExamManagement from "../../models/ExamManagement";
import axios from "../../services/axios";

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
    UPDATE_CURRENT_EXAM(state, payload) {
      state.currentExam = payload
    },
    DELETE_EXAM(state, payload) {
      const index = state.exams.findIndex(record => record.id === payload.id);
      state.exams.splice(index, 1)
    },
    ADD_REQUEST_CURRENT_EXAM(state, payload) {
      state.currentExam.exam_requests.push(payload)
    },
    UPDATE_REQUEST_CURRENT_EXAM(state, payload) {
      const index = state.currentExam.exam_requests.findIndex(record => record.id === payload.id);
      state.currentExam.exam_requests.splice(index, 1, payload)
    },
    DELETE_REQUEST_CURRENT_EXAM(state, payload) {
      const index = state.currentExam.exam_requests.findIndex(record => record.id === payload.id);
      state.currentExam.exam_requests.splice(index, 1)
    },
    ADD_FILE_REQUEST_CURRENT_EXAM(state, payload) {
      const index = state.currentExam.exam_requests.findIndex(record => record.id === payload.exam_request_id);
      const indexFile = state.currentExam.exam_requests[index].exam_request_files.findIndex(record => record.id === payload.id);
      state.currentExam.exam_requests[index].exam_request_files.push(payload)
    },
    DELETE_FILE_REQUEST_CURRENT_EXAM(state, payload) {
      const index = state.currentExam.exam_requests.findIndex(record => record.id === payload.exam_request_id);
      const indexFile = state.currentExam.exam_requests[index].exam_request_files.findIndex(record => record.id === payload.id);
      state.currentExam.exam_requests[index].exam_request_files.splice(indexFile, 1)
    },
  },
  actions: {
    async getExams({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getExams = mapAuthProviders[rootState.shared.settings.authProvider].getExams
        getExams()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });

            if (success) {
              const data = success.data
              const exams = []
              for (const examItem of data) {
                exams.push(new ExamManagement(
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
              commit('SET_EXAMS', exams)
              return success
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
      // } finally { commit("setLoading", false, { root: true }); }
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
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
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
              commit('UPDATE_CURRENT_EXAM', new ExamManagement(
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
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
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
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
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
    async getExamById({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const getExamById = mapAuthProviders[rootState.shared.settings.authProvider].getExamById
        getExamById(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              console.log(success)
              const data = success.data
              commit('SET_CURRENT_EXAM', new ExamManagement(
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
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
      // } finally { commit("setLoading", false, { root: true }) }
    },
    async createExamRequest({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const createExamRequest = mapAuthProviders[rootState.shared.settings.authProvider].createExamRequest
        createExamRequest(payload)
          .then((success) => {
            if (success) {
              const data = success.data
              commit('ADD_REQUEST_CURRENT_EXAM', data)
              return success
            }
            if (!success) {
              console.error('Not success', success)
            }
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
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
    async updateExamRequest({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const updateExamRequest = mapAuthProviders[rootState.shared.settings.authProvider].updateExamRequest
        updateExamRequest(payload)
          .then((success) => {
            if (success) {
              const data = success.data
              commit('UPDATE_REQUEST_CURRENT_EXAM', data)
              return success
            }
            if (!success) {
              console.error('Not success', success)
            }
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
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
    async deleteExamRequest({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const deleteExamRequest = mapAuthProviders[rootState.shared.settings.authProvider].deleteExamRequest
        deleteExamRequest(payload)
          .then((success) => {
            if (success) {
              const data = success.data
              commit('DELETE_REQUEST_CURRENT_EXAM', data)
              return success
            }
            if (!success) {
              console.error('Not success', success)
            }
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
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
    async uploadExamRequestFile({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const uploadExamRequestFile = mapAuthProviders[rootState.shared.settings.authProvider].uploadExamRequestFile
        uploadExamRequestFile(payload)
          .then((success) => {
            if (success) {
              const data = success
              commit('ADD_FILE_REQUEST_CURRENT_EXAM', data)
              return success
            }
            if (!success) {
              console.error('Not success', success)
            }
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
          })
      } catch (error) {
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error;
      } finally {
        commit("setLoading", false, { root: true })
      }
    },
    async deleteExamRequestFile({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const deleteExamRequestFile = mapAuthProviders[rootState.shared.settings.authProvider].deleteExamRequestFile
        deleteExamRequestFile(payload)
          .then((success) => {
            if (success) {
              const data = success
              commit('DELETE_FILE_REQUEST_CURRENT_EXAM', data)
              return success
            }
            if (!success) {
              console.error('Not success', success)
            }
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
          })
      } catch (error) {
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error;
      } finally {
        commit("setLoading", false, { root: true })
      }
    },
  },
  getters: {
    exams: state => state.exams,
    currentExam: state => state.currentExam
  },
};
