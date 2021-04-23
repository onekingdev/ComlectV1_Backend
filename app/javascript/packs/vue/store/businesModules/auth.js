import axios from '../../services/axios'

export default {
  state: {
    user: [],
    accessToken: '',
    loggedIn: false,
  },
  mutations: {
    updateUser(state, payload) {
      state.user = payload;
    },
    updateToken(state, payload) {
      state.accessToken = payload;
    },
    loggedIn(state, payload) {
      state.loggedIn = payload
    }
  },
  actions: {
    async singUp({commit}, payload) {
      console.log('payload', payload)
      try {
        commit("clearError");
        commit("setLoading", true);

        const endPoint = payload.business ? 'businesses' : 'specialists'
        const response = await axios.post(`/${endPoint}`, payload)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async singOut({commit}, payload) {
      console.log('payload', payload)
      try {
        commit("clearError");
        commit("setLoading", true);

        const endPoint = payload.business ? 'businesses' : 'specialists'
        const response = await axios.delete(`/${endPoint}`, payload)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async confirmEmail({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const response = await axios.put(`/users/${payload.userId}/confirm_email`, {
          "otp_secret": payload.code
        })
        if (response.data) {
          if(response.data.token) {
            commit('updateToken', response.data.token)
            localStorage.setItem('app.currentUser', JSON.stringify(response.data.token));
            commit('loggedIn', true)
          }
          if(response.data.business) commit('updateUser', response.data.business)
          if(response.data.specialist) commit('updateUser', response.data.specialist)
        }
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async getInfoByCRDNumber({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const response = await axios.put(`/crd/`, payload)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async updateBusinnesInfo({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);
        console.log('payload', payload)

        const response = await axios.patch(`/business`, payload)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async updateSubscribe({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);
        console.log('payload', payload)

        const endPoint = payload.business ? 'business' : 'specialist'
        const response = await axios.post(`/${endPoint}/upgrade/subscribe`, { plan: payload.plan })
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async generatePaymentMethod({commit, getters}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);
        console.log('payload', payload)

        const endPoint = payload.business ? 'business' : 'specialist'
        const response = await axios.post(`/${endPoint}/payment_settings?stripeToken=${payload.stripeToken}`)
        console.log('stripeToken response', response)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
  },
  getters: {
    getUser(state) {
      return state.user;
    },
    loggedIn(state) {
      return state.loggedIn
    },
    accessToken(state) {
      return state.accessToken
    },
  },
};
