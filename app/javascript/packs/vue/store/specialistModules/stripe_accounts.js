import { StripeAccount } from "../../models/StripeAccount";
import * as jwt from "@/services/specialist/stripe_accounts";

const mapAuthProviders = {
  jwt: {
    getStripeAccount: jwt.getStripeAccount,
    createStripeAccount: jwt.createStripeAccount,
    updateStripeAccount: jwt.updateStripeAccount
  }
};

const state = {
  stripeAccount: {}
}

const getters = {
  stripeAccount: state => state.stripeAccount
};

const actions = {
  async getStripeAccount({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });

      try {
        const authProvider = mapAuthProviders[rootState.shared.settings.authProvider]
        const data = authProvider.getStripeAccount()
          .then((response) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });

            if (response) {
              const data = response.data;
              commit("setStripeAccount", new StripeAccount(
                {
                  id: data.id,
                  dob: data.dob,
                  city: data.city,
                  state: data.state,
                  country: data.country,
                  zipcode: data.zipcode,
                  address1: data.address1,
                  last_name: data.last_name,
                  first_name: data.first_name,
                  account_type: data.account_type,
                  business_name: data.business_name,
                  business_tax_id: data.business_tax_id,
                  personal_id_number: data.personal_id_number
                }
              ));

              return data;
            }

            if (!response) {
              console.error("Not success", response)
              commit("setError", response.message, { root: true });
            }
          })
          .catch(error => error)

        return data;
      } catch (error) {
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
  },
  async createStripeAccount({ commit, rootState }, payload) {
    commit("clearError", null, { root: true });
    commit("setLoading", true, { root: true });

    try {
      const authProvider = mapAuthProviders[rootState.shared.settings.authProvider]
      const data = await authProvider.createStripeAccount(payload)
        .then((response) => {
          commit("clearError", null, { root: true });
          commit("setLoading", false, { root: true });

          if (response) {
            const data = response.data;

            if (!data.error && !data.errors) {
              commit("setStripeAccount", new StripeAccount(
                {
                  id: data.id,
                  country: data.country,
                  last_name: data.last_name,
                  first_name: data.first_name,
                  account_type: data.account_type,
                  business_name: data.business_name
                }
              ));
            }

            return response.data;
          }
        })
        .catch(error => error)
      return data
    } catch (error) {
      commit("setError", error.message, { root: true });
      commit("setLoading", false, { root: true });
      throw error;
    }
  },
  async updateStripeAccount({ commit, rootState }, payload) {
    commit("clearError", null, { root: true });
    commit("setLoading", true, { root: true });

    try {
      const authProvider = mapAuthProviders[rootState.shared.settings.authProvider]
      const data = await authProvider.updateStripeAccount(payload)
        .then((response) => {
          commit("clearError", null, { root: true });
          commit("setLoading", false, { root: true });

          if (response) {
            const data = response.data;

            if (!data.error && !data.errors) {
              commit("setStripeAccount", new StripeAccount(
                {
                  id: data.id,
                  dob: data.dob,
                  city: data.city,
                  state: data.state,
                  country: data.country,
                  zipcode: data.zipcode,
                  address1: data.address1,
                  last_name: data.last_name,
                  first_name: data.first_name,
                  account_type: data.account_type,
                  business_name: data.business_name,
                  business_tax_id: data.business_tax_id,
                  personal_id_number: data.personal_id_number
                }
              ));
            }

            return response.data;
          }
        })
        .catch(error => error)
      return data
    } catch (error) {
      commit("setError", error.message, { root: true });
      commit("setLoading", false, { root: true });
      throw error;
    }
  }
};

const mutations = {
  setStripeAccount: (state, stripeAccount) => (state.stripeAccount = stripeAccount)
};

export default {
  state,
  getters,
  actions,
  mutations
}
