// import * as business from '../../services/business'
//
// const mapAuthProviders = {
//   business: {
//     login: jwt.login,
//     register: jwt.register,
//     currentAccount: jwt.currentAccount,
//     logout: jwt.logout,
//     createPolicy: jwt.createPolicy,
//   },
// }

// class Risk {
//   constructor(created_at, description, id, name, position, sections = null, src_id, status, updated_at) {
//     this.created_at = created_at,
//       this.description = description,
//       this.id = id,
//       this.name = name,
//       this.position = position,
//       this.sections = sections,
//       this.srcId = src_id,
//       this.status = status,
//       this.updated_at = updated_at
//   }
// }

export default {
  state: {
    risks: [],
    // currentRisk: {}
  },
  mutations: {
    // RISKS
    updatetRisksList(state, payload) {
      state.risks = payload;
    },
    addRisk(state, payload) {
      state.risks.push(payload)
    },
    updateRisk(state, payload) {
      const index = state.risks.findIndex(record => record.id === payload.id);
      state.risks.splice(index, 1, payload)
    },
    deleteRisk(state, payload) {
      const index = state.risks.findIndex(record => record.id === payload.id);
      state.risks.splice(index, 1)
    },
    // updateCurrentRisk(state, payload) {
    //   state.currentRisk = payload
    // }
  },
  actions: {
    // RISKS
    async getRisks ({commit}) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/risks'
        const data = await fetch(`${endpointUrl}`, { headers: {'Accept': 'application/json'}})
          .then(response => {
            return response.json()
          })
          .then(response => {
            commit('updatetRisksList', response)
            return response
          })
          .catch(error => {
            console.error(error)
            throw error
          })
          .finally(() => commit("setLoading", false))

        return data;

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async createRisk({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/risks'
        const data = await fetch(`${endpointUrl}`, {
          method: 'POST',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
          body: JSON.stringify(payload)
        }).then(response => {
          if (!response.ok)
            throw new Error(`Could't publish Risk (${response.status})`);
          return response.json()
        }).then(response => {
          commit("addRisk", {...response});
          return response
        }).catch (error => {
          console.error(error)
          throw error;
        }).finally(() => commit("setLoading", false))

        return data;

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async updateRisk({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/risks'
        const data = await fetch(`${endpointUrl}/${payload.id}`, {
          method: 'PUT',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
          body: JSON.stringify(payload)
        }).then(response => {
          if (!response.ok)
            throw new Error(`Could't update Risk (${response.status})`);
          return response.json()
        }).then(response => {
          commit("updateRisk", {...response});
          // commit("updateCurrentRisk", response);
          return response
        }).catch (error => {
          console.error(error)
          throw error;
        }).finally(() => commit("setLoading", false))

        return data;

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async deleteRisk({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/risks'
        const data = await fetch(`${endpointUrl}/${payload.id}`, {
          method: 'DELETE',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
        }).then(response => {
          if (!response.ok)
            throw new Error(`Could't update Risk (${response.status})`);
          return response.json()
        }).then(response => {
          commit("deleteRisk", {...response});
          return response
        }).catch (error => {
          console.error(error)
          throw error;
        }).finally(() => commit("setLoading", false))

        return data;

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async getRiskById ({commit, getters}, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/risks/'
        const data = await fetch(`${endpointUrl}${payload.riskId}`, { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(response => {
            // commit('updateCurrentRisk', response)
            return response
          })
          .catch(error => {
            console.error(error)
            throw error
          })
          .finally(() => commit("setLoading", false))

        return data;

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
  },
  getters: {
    // RISKS
    risksList(state) {
      return state.risks.sort((a, b) => a.id - b.id);
    },
    riskById (state) {
      return riskId => {
        return state.risks.find(risk => risk.id === riskId)
      }
    },
    // getCurrentRisk(state) {
    //   return state.currentRisk
    // }
  },
};
