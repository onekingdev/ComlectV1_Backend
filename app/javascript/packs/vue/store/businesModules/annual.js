import AnnualReview from "../../models/AnnualReview";

const TOKEN = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImV4cCI6MTYyMDQ3MDM5Mn0.jp3-SuC06LNObDxmw_SrIFFkEO0MCrqzUAGIh0licT4'

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
    }
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
            'Authorization': `Bearer ${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(payload)
        })
        if (!response.ok) {
          throw new Error(`Could't create review (${response.status})`);
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
            'Authorization': `Bearer ${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        })
        if (!response.ok) {
          throw new Error(`Could't create review (${response.status})`);
        }
        const data = await response.json()
        const reviews = []
        console.log(data)
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
            annualItem.year
          ))
        }
        commit('SET_REVIEWS', reviews)
        return reviews
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
            'Authorization': `Bearer ${TOKEN}`,
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
          data.year
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
            'Authorization': `Bearer ${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(payload)
        })
        if (!response.ok) {
          throw new Error(`Could't update review (${response.status})`);
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
            'Authorization': `Bearer ${TOKEN}`,
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
            'Authorization': `Bearer ${TOKEN}`,
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
