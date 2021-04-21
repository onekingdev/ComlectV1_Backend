import axios from '../../services/axios'
// import axios from 'axios'

export default {
  state: {
    user: [],
    accessToken: ''
  },
  mutations: {
    updateUser(state, payload) {
      state.user = payload;
    },
    updateToken(state, payload) {
      state.accessToken = payload;
    },
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
    async confirmEmail({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const response = await axios.put(`/users/${payload.userId}/confirm_email`, {
          "otp_secret": payload.code
        })
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

        const response = await axios.post(`/upgrade/subscribe`, payload)
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
  },
};
