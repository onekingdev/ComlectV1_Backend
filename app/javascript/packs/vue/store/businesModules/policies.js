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

const TOKEN = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImV4cCI6MTYxOTAyMDQwOH0.lnBshrpoodRs2E-cr2l8yXM3fsqUcH1V8hWrEK4H2BU'

class Policy {
  constructor(created_at, description, id, name, position, sections = null, src_id, status, updated_at) {
    this.created_at = created_at,
    this.description = description,
    this.id = id,
    this.name = name,
    this.position = position,
    this.sections = sections,
    this.srcId = src_id,
    this.status = status,
    this.updated_at = updated_at
  }
}

export default {
  state: {
    policies: [],
    risks: [],
  },
  mutations: {
    // POLICIES
    createPolicy(state, payload) {
      state.policies.push(payload);
    },
    updatePolicy(state, payload) {
      const index = state.policies.findIndex(record => record.id === payload.id);
      state.policies.splice(index, 1, payload)
      // state.policies[index] = payload; // not reactive might be
      // const newArr = state.policies.map(record => (record.id === payload.id) ? payload : record)
      // state.policies = newArr
    },
    deletePolicy(state, payload) {
      const index = state.policies.findIndex(record => record.id === payload.id);
      state.policies.splice(index, 1)
    },
    updatePoliciesList(state, payload) {
      state.policies = payload;
    },
    updatePolicySectionsById(state, payload) {
      const index = state.policies.findIndex(record => record.id === payload.id);
      state.policies[index].sections.push(payload.sections);
      // const policy = state.policies.find(record => record.id === payload.id);
      // policy.sections.push(payload.sections);
    },

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
  },
  actions: {
    // POLICIES
    // async CREATE_POLICY({ commit, rootState }, { payload }) {
    //   console.log(payload)
    //   const { currentPage, pageSize } = payload
    //   commit("clearError");
    //   commit("setLoading", true);
    //
    //   const createPolicy = mapAuthProviders[rootState.settings.authProvider].createPolicy
    //   createPolicy(currentPage, pageSize).then((success) => {
    //     if (success) {
    //       console.log(success)
    //     }
    //     if (!success) {
    //       console.log(success)
    //     }
    //     commit("clearError");
    //     commit("setLoading", false);
    //   })
    // },
    async createPolicy({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const data = await fetch('/api/business/compliance_policies', {
          method: 'POST',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
          body: JSON.stringify({
            name: payload.name
          })
        }).then(response => {
          if (!response.ok)  throw new Error(`Could't create policy (${response.status})`)
          return response.json()
        }).then(response => {
          if (response.errors) return response
          const newPolicy = new Policy(
            response.created_at,
            response.description,
            response.id,
            response.name,
            response.position,
            response.sections,
            response.src_id,
            response.status,
            response.updated_at
          );
          commit("createPolicy", newPolicy);
          console.log('newPolicy', newPolicy)
          return response
        }).catch (error => {
          throw error;
        })
          .finally(() => commit("setLoading", false))
        return data
      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async updatePolicy({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const data = await fetch('/api/business/compliance_policies/' + payload.id, {
          method: 'PUT',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
          body: JSON.stringify({...payload})
        }).then(response => {
          // console.log(response)
          if (!response.ok)
            throw new Error(`Could't update policy (${response.status})`);
          return response.json()
        }).then(response => {
          const updatePolicy = new Policy(
            response.created_at,
            response.description,
            response.id,
            response.name,
            response.position,
            response.sections,
            response.src_id,
            response.status,
            response.updated_at
          );
          commit("updatePolicy", {...updatePolicy});
          return response
        }).catch (error => {
          // console.error(error)
          throw error;
        })
          .finally(() => commit("setLoading", false))

        return data;

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async downloadPolicy({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/compliance_policies/'
        const data = await fetch(`${endpointUrl}${payload.policyId}/download`, {
          method: 'GET',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
        }).then(response => {
          console.log(response)
          if (!response.ok)
            throw new Error(`Could't download policy (${response.status})`);
          return response.json()
        }).then(response => {
          console.log(response)
          return response
        }).catch (error => {
          console.error(error)
          throw error;
        }).finally(() => commit("setLoading", false))

        console.log('data', data)

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async publishPolicy({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/compliance_policies/'
        const data = await fetch(`${endpointUrl}${payload.policyId}/publish`, {
          method: 'GET',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
        }).then(response => {
          if (!response.ok)
            throw new Error(`Could't publish policy (${response.status})`);
          return response.json()
        }).then(response => {
          commit("updatePolicy", {
            id: response.id,
            ...response,
          });
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
    async getPolicies ({commit, getters}, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/compliance_policies'
        const data = await fetch(`${endpointUrl}`, { headers: {'Accept': 'application/json'}})
          .then(response => {
            return response.json()
          })
          .then(response => {
            commit('updatePoliciesList', response)
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
    updatePolicySectionsById ({commit, getters}, payload) {
      console.log('payload', payload)
      commit('updatePolicySectionsById', {
        ...payload
      })
    },
    async getPolicyById ({commit, getters}, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/compliance_policies/'
        const data = await fetch(`${endpointUrl}${payload.policyId}`, { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(response => {
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
    async movePolicy({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const data = fetch('/api/business/compliance_policies/' + payload.id, {
          method: 'PATCH',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
          body: JSON.stringify({
            position: payload.position,
          })
        }).then(response => {
          // console.log(response)
          if (!response.ok)
            throw new Error(`Could't update policy (${response.status})`);
          return response.json()
        }).then(response => {
          commit('updatePolicy', {
            ...response
          })
          return response
        }).catch (error => {
          // console.error(error)
          throw error;
        })
          .finally(() => commit("setLoading", false))

        return data;

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }

      // FOR MULTIPLE REQUEST - NOT SUPPORT BACK END
      // const [policy1, policy2] = [...payload]
      // console.log(policy1, policy2)
      //
      // const data = await Promise.all([
      //   fetch('/api/business/compliance_policies/' + policy1.id, {
      //     method: 'PATCH',
      //     headers: {
      //       // 'Authorization': 'Bearer test',
      //       'Accept': 'application/json',
      //       'Content-Type': 'application/json'},
      //     body: JSON.stringify({
      //         position: policy1.position,
      //     }),
      //   }),
      //   fetch('/api/business/compliance_policies/' + policy2.id, {
      //     method: 'PATCH',
      //     headers: {
      //       // 'Authorization': 'Bearer test',
      //       'Accept': 'application/json',
      //       'Content-Type': 'application/json'
      //     },
      //     body: JSON.stringify({
      //       position: policy2.position,
      //     })
      //   }),
      // ]).then(function (responses) {
      //   // Get a JSON object from each of the responses
      //   return Promise.all(responses.map(function (response) {
      //     return response.json();
      //   }));
      // }).then(function (data) {
      //   // Log the data to the console
      //   // You would do something with both sets of data here
      //   console.log(data);
      //   data.forEach(function (response) {
      //     commit('updatePolicyById', {
      //       ...response
      //     })
      //   })
      // }).catch(function (error) {
      //   // if there's an error, log it
      //   console.log(error);
      // })
      //   .finally(() => commit("setLoading", false))
      //
      // console.log(data);
    },
    async deletePolicyById ({commit, getters}, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/compliance_policies/'
        const data = await fetch(`${endpointUrl}${payload.policyId}`, { method: 'DELETE', headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(response => {
            commit('deletePolicy', {id: response.id})
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
    async archivePolicyById ({commit, getters}, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/compliance_policies/'
        const data = await fetch(`${endpointUrl}${payload.policyId}`, {
          method: 'PATCH',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
          body: JSON.stringify({
            archived: payload.archived
          })
        })
          .then(response => response.json())
          .then(response => {
            commit('updatePolicy', {...response})
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
          method: 'POST',
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
          method: 'POST',
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

    // CONFIG PAGE (SETUP)
    async getPolicyConfig({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const data = await fetch('/api/business/compliance_policy_configuration', {
          method: 'GET',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'}
        }).then(response => {
          if (!response.ok)  throw new Error(`Could't create Policy Config (${response.status})`)
          return response.json()
        }).then(response => {
          if (response.errors) return response
          console.log('getPolicyConfig', response)
          return response
        }).catch (error => {
          throw error;
        })
          .finally(() => commit("setLoading", false))
        return data
      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async postPolicyConfig({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const data = await fetch('/api/business/compliance_policy_configuration', {
          method: 'PATCH',
          headers: {
            'Authorization': `Bearer ${TOKEN}`,
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data'},
          body: JSON.stringify({
            logo_data: payload.logo,
            address: payload.address,
            phone: payload.phone,
            email: payload.email,
            disclosure: payload.disclosure,
            body: payload.body
          })
        }).then(response => {
          if (!response.ok)  throw new Error(`Could't create policy config (${response.status})`)
          return response.json()
        }).then(response => {
          if (response.errors) return response
          console.log('postPolicyConfig', response)
          return response
        }).catch (error => {
          throw error;
        })
          .finally(() => commit("setLoading", false))
        return data
      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
  },
  getters: {
    // POLICIES
    policiesList(state) {
      return state.policies;
    },
    policiesListNested(state) {
      let tmp;
      const newPoliciesList = state.policies.map(el => {
        tmp = el['name'];
        el['title'] = tmp;
        tmp = el['sections']
        el['children'] = tmp;
        if (!el['sections']) el['sections'] = []
        return el
      });
      newPoliciesList.sort((a, b) => a.position - b.position)
      return newPoliciesList;
    },
    policyById (state) {
      return policyId => {
        return state.policies.find(policy => policy.id === policyId)
      }
    },
    policiesListArchived (state, getters) {
      return getters.policiesListNested.filter(policy => policy.archived)
    },
    policiesListUnArchived (state, getters) {
      return getters.policiesListNested.filter(policy => !policy.archived)
    },

    // RISKS
    risksList(state) {
      return state.risks;
    },
  },
};
