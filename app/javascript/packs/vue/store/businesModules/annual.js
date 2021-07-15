import axios from '../../services/axios'

import AnnualReview from "../../models/AnnualReview";

// HOOK TO NOT REWITE ALL REQUESTS
const TOKEN = localStorage.getItem('app.currentUser.token') ? JSON.parse(localStorage.getItem('app.currentUser.token')) : ''


export default {
  state: {
    reviews: [],
    currentReview: null,
  },
  mutations: {
    SET_REVIEWS (state, payload) {
      state.reviews = payload
    },
    SET_CURRENT_REVIEW (state, payload) {
      state.currentReview = payload
    },
    SET_NEW_REVIEW (state, payload) {
      state.reviews.push(payload)
    },
    UPDATE_REVIEW (state, payload) {
      const index = state.reviews.findIndex(record => record.id === payload.id);
      state.reviews.splice(index, 1, payload)
    },
    DELETE_REVIEW (state, payload) {
      const index = state.reviews.findIndex(record => record.id === payload.id);
      state.reviews.splice(index, 1)
    },
  },
  actions: {
    async createReview({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await fetch('/api/business/annual_reports', {
          method: 'POST',
          headers: {
            'Authorization': `${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(payload)
        })
        if (!response.ok) {
          throw new Error(`Could't create review (${response.status})`);
        }
        const data = await response.json()
        if (data) commit('SET_NEW_REVIEW', new AnnualReview(
          data.annual_review_employees,
          data.business_id,
          data.created_at,
          data.exam_end,
          data.exam_start,
          data.id,
          data.material_business_changes,
          data.pdf_url,
          data.regulatory_changes,
          data.review_categories,
          data.review_end,
          data.review_start,
          data.updated_at,
          data.year,
          data.name
        ))
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
    async getReviews({ commit }) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await fetch('/api/business/annual_reports', {
          method: 'GET',
          headers: {
            'Authorization': `${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        })
        const data = await response.json()
        const reviews = []
        for (const annualItem of data) {
          reviews.push(new AnnualReview(
            annualItem.annual_review_employees,
            annualItem.business_id,
            annualItem.created_at,
            annualItem.exam_end,
            annualItem.exam_start,
            annualItem.id,
            annualItem.material_business_changes,
            annualItem.pdf_url,
            annualItem.regulatory_changes,
            annualItem.review_categories,
            annualItem.review_end,
            annualItem.review_start,
            annualItem.updated_at,
            annualItem.year,
            annualItem.name
          ))
        }
        commit('SET_REVIEWS', reviews)
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
    async getCurrentReview({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await fetch(`/api/business/annual_reports/${payload}`, {
          method: 'GET',
          headers: {
            'Authorization': `${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        })
        if (!response.ok) {
          throw new Error(`Could't create review (${response.status})`);
        }
        const data = await response.json()
        commit('SET_CURRENT_REVIEW', new AnnualReview(
          data.annual_review_employees,
          data.business_id,
          data.created_at,
          data.exam_end,
          data.exam_start,
          data.id,
          data.material_business_changes,
          data.pdf_url,
          data.regulatory_changes,
          data.review_categories,
          data.review_end,
          data.review_start,
          data.updated_at,
          data.year,
          data.name
        ))
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
    async updateReview({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await fetch(`/api/business/annual_reports/${payload.id}`, {
          method: 'PATCH',
          headers: {
            'Authorization': `${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(payload)
        })
        if (!response.ok) {
          throw new Error(`Could't update review (${response.status})`);
        }
        const data = await response.json()
        if (data) commit('UPDATE_REVIEW', new AnnualReview(
          data.annual_review_employees,
          data.business_id,
          data.created_at,
          data.exam_end,
          data.exam_start,
          data.id,
          data.material_business_changes,
          data.pdf_url,
          data.regulatory_changes,
          data.review_categories,
          data.review_end,
          data.review_start,
          data.updated_at,
          data.year,
          data.name
        ))
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
    async duplicateReview({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await axios.get(`business/annual_reports/${payload.id}/clone`)
        if (response.data) commit('SET_NEW_REVIEW', new AnnualReview(
          response.data.annual_review_employees,
          response.data.business_id,
          response.data.created_at,
          response.data.exam_end,
          response.data.exam_start,
          response.data.id,
          response.data.material_business_changes,
          response.data.pdf_url,
          response.data.regulatory_changes,
          response.data.review_categories,
          response.data.review_end,
          response.data.review_start,
          response.data.updated_at,
          response.data.year,
          response.data.name
        ))
        return response.data
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
    async deleteReview({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await axios.delete(`business/annual_reports/${payload.id}`)
        commit('DELETE_REVIEW', response.data )
        return response.data
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
    async updateReviewCategory({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await fetch(`/api/business/annual_reports/${payload.annualId}/review_categories/${payload.id}`, {
          method: 'PATCH',
          headers: {
            'Authorization': `${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(payload)
        })
        if (!response.ok) {
          throw new Error(`Could't update review category (${response.status})`);
        }
        const data = await response.json()
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
    async createReviewCategory({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await fetch(`/api/business/annual_reports/${payload.annualId}/review_categories`, {
          method: 'POST',
          headers: {
            'Authorization': `${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(payload)
        })
        if (!response.ok) {
          throw new Error(`Could't create review category (${response.status})`);
        }
        const data = await response.json()
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
    async deleteReviewCategory({ commit }, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const response = await fetch(`/api/business/annual_reports/${payload.annualId}/review_categories/${payload.id}`, {
          method: 'DELETE',
          headers: {
            'Authorization': `${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(payload)
        })
        if (!response.ok) {
          throw new Error(`Could't create review category (${response.status})`);
        }
        const data = await response.json()
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
    }
  },
  getters: {
    reviews: state => state.reviews,
    currentReview: state => state.currentReview
  },
};
