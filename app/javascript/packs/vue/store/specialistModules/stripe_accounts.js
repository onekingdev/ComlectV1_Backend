import { StripeAccount } from "../../models/StripeAccount";
import * as jwt from "@/services/specialist/stripe_accounts";

const mapAuthProviders = {
  jwt: {
    getStripeAccount: jwt.getStripeAccount,
    createStripeAccount: jwt.createStripeAccount,
    updateStripeAccount: jwt.updateStripeAccount
  }
};

// stripeAccount: null
// const state = {
//   stripeAccount: {
//     id: 1,
//     country: "US",
//     account_type: { value: "individual", name: "Individual" }
//   }
// };

const state = {
  stripeAccount: {}
}

const getters = {
  stripeAccount: (state) => state.stripeAccount
};

const actions = {
  async getStripeAccount({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });

      try {
        const authProvider = mapAuthProviders[rootState.shared.settings.authProvider]
        const data = authProvider.getStripeAccount()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });

            if (success) {
              const data = success.data;
              commit("ADD_STRIPE_ACCOUNT", new StripeAccount(
                {
                  country: data.country,
                  last_name: data.last_name,
                  first_name: data.first_name,
                  account_type: data.account_type,
                  business_name: data.business_name
                }
              ));
              return data;
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)
        return data
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

            return response.data
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
