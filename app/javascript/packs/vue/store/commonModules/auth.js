import axios from '../../services/axios'

import { AccountInfoBusiness, AccountInfoSpecialist } from "../../models/AccountInfo";

const currentUserLocalStorage = localStorage.getItem('app.currentUser') ? localStorage.getItem('app.currentUser') : ''
const accessTokenLocalStorage = localStorage.getItem('app.currentUser.token') ? localStorage.getItem('app.currentUser.token') : ''
const GOOGLE_API_KEY = process.env.GOOGLE_PLACES_API_KEY

export default {
  state: {
    currentUser: currentUserLocalStorage ? JSON.parse(currentUserLocalStorage) : {},
    accessToken: accessTokenLocalStorage ? JSON.parse(accessTokenLocalStorage) : '',
    loggedIn: false,
  },
  mutations: {
    UPDATE_USER(state, payload) {
      state.currentUser = payload;
    },
    UPDATE_TOKEN(state, payload) {
      state.accessToken = payload;
    },
    UPDATE_LOGIN_STATUS(state, payload) {
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
            commit('UPDATE_TOKEN', response.data.token)
            localStorage.setItem('app.currentUser.token', JSON.stringify(response.data.token));
            commit('UPDATE_LOGIN_STATUS', true)
          }
          if(response.data.business) {
            const data = response.data.business
            commit('UPDATE_USER', new AccountInfoBusiness(
              data.apartment,
              data.aum,
              data.business_name,
              data.city,
              data.client_account_cnt,
              data.contact_first_name,
              data.contact_last_name,
              data.crd_number,
              data.id,
              data.industries,
              data.jurisdictions,
              data.state,
              data.sub_industries,
              data.username,
              data.address_1,
              data.address_2,
              data.contact_phone,
              data.website,
              data.zipcode
            ))
            localStorage.setItem('app.currentUser', JSON.stringify(data));
          }
          if(response.data.specialist) {
            const data = response.data.specialist
            commit('UPDATE_USER', new AccountInfoSpecialist(
              data.experience,
              data.first_name,
              data.former_regulator,
              data.id,
              data.industries,
              data.last_name,
              data.resume_url,
              data.skills,
              data.username
            ))
            localStorage.setItem('app.currentUser', JSON.stringify(data));
          }
        }
        return response.data

      } catch (error) {
        console.error('error auth', error);
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
            commit('UPDATE_TOKEN', response.data.token)
            localStorage.setItem('app.currentUser.token', JSON.stringify(response.data.token));
            commit('UPDATE_LOGIN_STATUS', true)
          }
          if(response.data.business) {
            const data = response.data.business
            commit('UPDATE_USER', new AccountInfoBusiness(
              data.apartment,
              data.aum,
              data.business_name,
              data.city,
              data.client_account_cnt,
              data.contact_first_name,
              data.contact_last_name,
              data.crd_number,
              data.id,
              data.industries,
              data.jurisdictions,
              data.state,
              data.sub_industries,
              data.username,
              data.address_1,
              data.address_2,
              data.contact_phone,
              data.website,
              data.zipcode
            ))
            localStorage.setItem('app.currentUser', JSON.stringify(data));
          }
          if(response.data.specialist) {
            const data = response.data.specialist
            commit('UPDATE_USER', new AccountInfoSpecialist(
              data.experience,
              data.first_name,
              data.former_regulator,
              data.id,
              data.industries,
              data.last_name,
              data.resume_url,
              data.skills,
              data.username
            ))
            localStorage.setItem('app.currentUser', JSON.stringify(data));
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
    async resetEmail({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const response = await axios.post(`/users/password`, payload)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async changeEmail({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const response = await axios.put(`/users/password`, payload)
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

        const response = await axios.patch(`/business`, payload)
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
          }
        };
        const data = { [endPointUserType]: payload[endPointUserType] };
        const response = await axios.patch(`/${endPointUserType}`, payload)
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
        if(response.data) {
          const data = response.data
          if (payload.business) commit('UPDATE_USER', new AccountInfoBusiness(
            data.apartment,
            data.aum,
            data.business_name,
            data.city,
            data.client_account_cnt,
            data.contact_first_name,
            data.contact_last_name,
            data.crd_number,
            data.id,
            data.industries,
            data.jurisdictions,
            data.state,
            data.sub_industries,
            data.username,
            data.address_1,
            data.address_2,
            data.contact_phone,
            data.website,
            data.zipcode
          ))
          if (!payload.business) commit('UPDATE_USER', new AccountInfoSpecialist(
            data.experience,
            data.first_name,
            data.former_regulator,
            data.id,
            data.industries,
            data.last_name,
            data.resume_url,
            data.skills,
            data.username
          ))
          if(!data.errors) localStorage.setItem('app.currentUser', JSON.stringify(data));
        }
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async updateAccountInfoWithFile({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);
        const config = {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        };
        const response = await axios.patch(`/specialist`, payload, config)
        if(response.data) {
          const data = response.data
          if (payload.business) commit('UPDATE_USER', new AccountInfoBusiness(
            data.apartment,
            data.aum,
            data.business_name,
            data.city,
            data.client_account_cnt,
            data.contact_first_name,
            data.contact_last_name,
            data.crd_number,
            data.id,
            data.industries,
            data.jurisdictions,
            data.state,
            data.sub_industries,
            data.username,
            data.address_1,
            data.address_2,
            data.contact_phone,
            data.website,
            data.zipcode
          ))
          if (!payload.business) commit('UPDATE_USER', new AccountInfoSpecialist(
            data.experience,
            data.first_name,
            data.former_regulator,
            data.id,
            data.industries,
            data.last_name,
            data.resume_url,
            data.skills,
            data.username
          ))
          if(!data.errors) localStorage.setItem('app.currentUser', JSON.stringify(data));
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
        axios.defaults.timeout = 60000;
        const response = await axios.post(`/${endPoint}/upgrade/subscribe`, { plan: planName, cnt: countPayedUsers }, { params: {
            payment_source_id: paymentSourceId
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

        // WAIT LONGER
        axios.defaults.timeout = 10000;

        const { userType, stripeToken } = { ...payload }

        const endPoint = userType === 'business' ? 'business/payment_settings' : 'specialist/payment_settings/create_card'
        // const response = await axios.post(`/${endPoint}/payment_settings?stripeToken=${payload.stripeToken}`)
        const response = await axios.post(`/${endPoint}`, null, { params: {
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
    async getSkills({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const response = await axios.get(`/skills`)
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
        return response.data

      } catch (error) {
        console.error(error);
        throw error
      } finally {
        commit("setLoading", false)
      }
    },
    async getGeo({commit}, payload) {
      try {
        const response = await axios.post(`https://maps.googleapis.com/maps/api/geocode/json?address=${payload}&key=${GOOGLE_API_KEY}`)
        return response
      } catch (error) {
        console.error(error);
        throw error
      } finally {
      }
    },
    async resendOTP({commit}, payload) {
      try {
        commit("clearError");
        commit("setLoading", true);

        const response = await axios.post(`/otp_secrets`, payload)
        // if (!response.ok) throw new Error(`Something wrong, (${response.status})`)
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
