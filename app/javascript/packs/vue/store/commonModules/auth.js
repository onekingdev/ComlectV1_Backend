import axios from '../../services/axios'

const currentUserLocalStorage = localStorage.getItem('app.currentUser') ? localStorage.getItem('app.currentUser') : ''
const accessTokenLocalStorage = localStorage.getItem('app.currentUser.token') ? localStorage.getItem('app.currentUser.token') : ''

export default {
  state: {
    currentUser: currentUserLocalStorage ? JSON.parse(currentUserLocalStorage) : {},
    accessToken: accessTokenLocalStorage ? JSON.parse(accessTokenLocalStorage) : '',
    loggedIn: false,
  },
  mutations: {
    updateUser(state, payload) {
      state.currentUser = payload;
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
            localStorage.setItem('app.currentUser.token', JSON.stringify(response.data.token));
            commit('loggedIn', true)
          }
          if(response.data.business) {
            localStorage.setItem('app.currentUser', JSON.stringify(response.data.business));
            commit('updateUser', response.data.business)
          }
          if(response.data.specialist) {
            localStorage.setItem('app.currentUser', JSON.stringify(response.data.specialist));
            commit('updateUser', response.data.specialist)
          }
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

        const { userType, paymentSourceId, planName } = { ...payload }

        const endPoint = userType ? 'business' : 'specialist'
        const response = await axios.post(`/${endPoint}/upgrade/subscribe`, { plan: planName }, { params: {
            payment_source_id: paymentSourceId
          }})
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

        // WAIT LONGER
        axios.defaults.timeout = 5000;

        const endPoint = payload.business ? 'business' : 'specialist'
        // const response = await axios.post(`/${endPoint}/payment_settings?stripeToken=${payload.stripeToken}`)
        const response = await axios.post(`/${endPoint}/payment_settings`, null, { params: {
            stripeToken: payload.stripeToken,
          }})
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
      return state.currentUser;
    },
    loggedIn(state) {
      return state.loggedIn
    },
    accessToken(state) {
      return state.accessToken
    },
  },
};
