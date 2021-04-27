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
    async singIn({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const response = await axios.post(`/users/sign_in`, payload)
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
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
    async singUp({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const endPoint = payload.business ? 'businesses' : 'specialists'
        const response = await axios.post(`/${endPoint}`, payload)
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async singOut({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const endPoint = payload.business ? 'businesses' : 'specialists'
        const response = await axios.delete(`/${endPoint}`, payload)
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
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
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
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
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async updateAccountInfo({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const endPointUserType = payload.business ? 'business' : 'specialist'
        const config = {
          headers: {
            'Content-Type': endPointUserType === 'specialist' ? 'multipart/form-data' : 'application/json',
          },
          [endPointUserType]: payload[endPointUserType],
        };
        const response = await axios.patch(`/${endPointUserType}`, config)
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
        if(response.data) {
          localStorage.setItem('app.currentUser', JSON.stringify(response.data));
          commit('updateUser', response.data)
        }
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

        const endPoint = userType === 'business' ? 'business' : 'specialist'
        // WAIT LONGER
        axios.defaults.timeout = 10000;
        const response = await axios.post(`/${endPoint}/upgrade/subscribe`, { plan: planName }, { params: {
            payment_source_id: paymentSourceId
          }})
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async updateSeatsSubscribe({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const { userType, paymentSourceId, planName, countPayedUsers } = { ...payload }
        const endPoint = userType === 'business' ? 'business' : 'specialist'

        // WAIT LONGER
        axios.defaults.timeout = 10000;
        const response = await axios.post(`/${endPoint}/upgrade/subscribe`, { plan: planName }, { params: {
            payment_source_id: paymentSourceId, cnt: countPayedUsers
          }})
        return response.data

        // let ids = [];
        // for(let i=1; i <= countPayedUsers; i++) {
        //   ids.push(i)
        // }
        // const promises = ids.map(() => axios.post(`/${endPoint}/upgrade/subscribe`, { plan: planName }, { params: {
        //     payment_source_id: paymentSourceId
        //   }}));
        //
        // const response = await Promise.all([...promises]).then(function (values) {
        //   // console.log(values);
        //   return values
        // });
        // return response

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

        // WAIT LONGER
        axios.defaults.timeout = 10000;

        const { userType, stripeToken } = { ...payload }

        const endPoint = userType === 'business' ? 'business' : 'specialist'
        // const response = await axios.post(`/${endPoint}/payment_settings?stripeToken=${payload.stripeToken}`)
        const response = await axios.post(`/${endPoint}/payment_settings`, null, { params: {
            stripeToken: stripeToken,
          }})
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async getPaymentMethod({commit, getters}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const { userType } = {...payload}
        const response = await axios.get(`/${userType}/payment_settings`)
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async deletePaymentMethod({commit, getters}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const { userType, id } = {...payload}
        const response = await axios.delete(`/${userType}/payment_settings/${id}`)
        if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
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
