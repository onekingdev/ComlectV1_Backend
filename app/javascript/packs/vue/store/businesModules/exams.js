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
    sendInvite: jwt.sendInvite,
    sendUninvite: jwt.sendUninvite,
    confirmEmail: jwt.confirmEmail,
    confirmOTP: jwt.confirmOTP,
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
      // const indexFile = state.currentExam.exam_requests[index].exam_request_files.findIndex(record => record.id === payload.id);
      state.currentExam.exam_requests[index].exam_request_files.push(payload)
    },
    DELETE_FILE_REQUEST_CURRENT_EXAM(state, payload) {
      const index = state.currentExam.exam_requests.findIndex(record => record.id === payload.exam_request_id);
      const indexFile = state.currentExam.exam_requests[index].exam_request_files.findIndex(record => record.id === payload.id);
      state.currentExam.exam_requests[index].exam_request_files.splice(indexFile, 1)
    },
    ADD_AUDITOR_CURRENT_EXAM(state, payload) {
      state.currentExam.exam_auditors.push(payload)
    },
    REMOVE_AUDITOR_CURRENT_EXAM(state, payload) {
      const index = state.currentExam.exam_auditors.findIndex(record => record.id === payload.auditorId);
      state.currentExam.exam_auditors.splice(index, 1)
    },
  },
  actions: {
    async getExams({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getExams = mapAuthProviders[rootState.shared.settings.authProvider].getExams
        const data = getExams()
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
                  examItem.exam_auditors,
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
          .catch(error => error)
        return data
      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
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
        const data = createExam(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('ADD_EXAM', new ExamManagement(
                  data.complete,
                  data.created_at,
                  data.ends_on,
                  data.exam_auditors,
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
      // } finally { commit("setLoading", false, { root: true }) }
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
        const data = updateExam(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('UPDATE_EXAM', new ExamManagement(
                  data.complete,
                  data.created_at,
                  data.ends_on,
                  data.exam_auditors,
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
                  data.exam_auditors,
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
      // } finally { commit("setLoading", false, { root: true }) }
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
        const data = deleteExam(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('DELETE_EXAM', new ExamManagement(
                  data.complete,
                  data.created_at,
                  data.ends_on,
                  data.exam_auditors,
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
      // } finally { commit("setLoading", false, { root: true }) }
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
        const data = getExamById(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              commit('SET_CURRENT_EXAM', new ExamManagement(
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_auditors,
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
        const data = createExamRequest(payload)
          .then((success) => {
            if (success) {
              const data = success.data
              data.text_items = data.text_items ? data.text_items.map(text => ({ text })) : []
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
        const data = updateExamRequest(payload)
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
        const data = deleteExamRequest(payload)
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
        const data = uploadExamRequestFile(payload)
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
          .catch(error => error)
        return data
        return data
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
        const data = deleteExamRequestFile(payload)
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
          .catch(error => error)
        return data
      } catch (error) {
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error;
      } finally {
        commit("setLoading", false, { root: true })
      }
    },
    async sendInvite({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const sendInvite = mapAuthProviders[rootState.shared.settings.authProvider].sendInvite
        const data = await sendInvite(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('ADD_AUDITOR_CURRENT_EXAM', data)
              return data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
              return success
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
    async sendUninvite({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const sendUninvite = mapAuthProviders[rootState.shared.settings.authProvider].sendUninvite
        const data = await sendUninvite(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('REMOVE_AUDITOR_CURRENT_EXAM', payload)
              return data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
              return success
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
    async confirmEmail({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const confirmEmail = mapAuthProviders[rootState.shared.settings.authProvider].confirmEmail
        const data = await confirmEmail(payload)
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
              return success
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
    async confirmOTP({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const confirmOTP = mapAuthProviders[rootState.shared.settings.authProvider].confirmOTP
        const data = await confirmOTP(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('SET_CURRENT_EXAM', new ExamManagement(
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_auditors,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
              ))
              return success.data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
              return success
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
  },
  getters: {
    exams: state => state.exams,
    currentExam: state => state.currentExam
  },
};
