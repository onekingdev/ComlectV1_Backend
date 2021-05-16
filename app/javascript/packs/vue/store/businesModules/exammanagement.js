import axios from '../../services/axios'

import ExamManagement from "../../models/ExamManagement";
import AnnualReview from "../../models/AnnualReview";

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
  },
  actions: {
    async getExams({commit}) {
      try {
        commit("clearError", null, {
          root: true
        });
        commit("setLoading", true, {
          root: true
        });

        const response = await axios.get(`/bussines/exams`)

        const data = response.data
        const exams = []
        console.log(data)
        for (const examItem of data) {
          exams.push(new ExamManagement(
            examItem.id,
            examItem.name,
            examItem.status,
            examItem.created_at,
            examItem.modified_at,
          ))
        }
        commit('SET_EXAMS', exams)
        return exams
      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false, {
          root: true
        });
      }
    },
    async createExam({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        console.log('payload', payload)
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
