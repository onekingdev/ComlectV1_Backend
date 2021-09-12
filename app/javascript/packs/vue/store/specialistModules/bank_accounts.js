import { BankAccount } from "../../models/BankAccount";
import * as jwt from "@/services/specialist/bank_accounts";

const mapAuthProviders = {
  jwt: {
    createBankAccount: jwt.createBankAccount
  }
};

const state = {
  bankAccount: {}
}

const getters = {
  stripeAccount: (state) => state.stripeAccount
};

const actions = {
  async createBankAccount({ commit, rootState }, payload) {
    commit("clearError", null, { root: true });
    commit("setLoading", true, { root: true });

    try {
      const authProvider = mapAuthProviders[rootState.shared.settings.authProvider]
      const data = await authProvider.createBankAccount(payload)
        .then((response) => {
          commit("clearError", null, { root: true });
          commit("setLoading", false, { root: true });

          if (response) {
            const data = response.data;

            commit("setBankAccount", new BankAccount(
              {
                id: data.id,
                account_number: data.account_number,
                routing_number: data.routing_number
              }
            ));

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
  setBankAccount: (state, bankAccount) => (state.bankAccount = bankAccount)
};

export default {
  state,
  getters,
  actions,
  mutations
}
