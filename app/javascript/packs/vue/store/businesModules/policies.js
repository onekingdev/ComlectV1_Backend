class Policy {
  constructor(policyID = null, ownerId = null, title, description, sections = null) {
    this.policyID = policyID;
    this.ownerId = ownerId;
    this.title = title;
    this.description = description;
    this.sections = sections;
  }
}

export default {
  state: {
    policies: [],
    sections: [],
  },
  mutations: {
    createPolicy(state, payload) {
      state.policies.push(payload);
    },
    updatePolicy(state, payload) {
      const index = state.policies.findIndex(record => record.policyID === payload.policyID);
      state.policies[index] = payload;
      // state.policies.map(record => (record.policyID === payload.policyID) ? payload : record)
    },
    createSections(state, payload) {
      state.sections.push(payload);
    },
    getPoliciesListFromDB(state, payload) {
      state.policies = payload;
    }
  },
  actions: {
    async createPolicy({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const newPolicy = new Policy(
          payload.policyID,
          payload.ownerId,
          payload.title,
          payload.description,
          payload.sections,
        );

        commit("setLoading", false);
        commit("createPolicy", {
          ...newPolicy,
        });

        const data = await fetch('/api/business/compliance_policies', {
          method: 'POST',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
          body: JSON.stringify({
            compliance_policy: {
              name: 'test2021',
              ...newPolicy
            }
          })
        }).then(response => {
          console.log(response)
          if (!response.ok)
            throw new Error(`Could't create policy (${response.status})`);
          return response.json()
        }).then(response => {
          console.log(response)
          return response
        }).catch (error => {
          console.error(error)
          throw error;
        })

        console.log('data', data)

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
        const updatePolicy = new Policy(
          payload.policyID,
          payload.ownerId,
          payload.title,
          payload.description,
          payload.sections,
        );

        console.log('updatePolicy', updatePolicy)

        console.log(JSON.stringify({
          compliance_policy: {
            name: updatePolicy.title,
            ...updatePolicy
          }
        }))

        const data = await fetch('/api/business/compliance_policies/' + payload.policyID, {
          method: 'PUT',
          headers: {
            // 'Authorization': 'Bearer test',
            'Accept': 'application/json',
            'Content-Type': 'application/json'},
          body: JSON.stringify({
            compliance_policy: {
              name: payload.title,
              ...updatePolicy
            }
          })
        }).then(response => {
          console.log(response)
          if (!response.ok)
            throw new Error(`Could't update policy (${response.status})`);
          return response.json()
        }).then(response => {
          console.log(response)

          commit("updatePolicy", {
            ...updatePolicy,
          });

          return response
        }).catch (error => {
          console.error(error)
          throw error;
        })
          .finally(() => commit("setLoading", false))


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
            policyID: response.id,
            ...response,
          });
          return response
        }).catch (error => {
          console.error(error)
          throw error;
        }).finally(() => commit("setLoading", false))

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
            commit('getPoliciesListFromDB', response)
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
    moveUpPolicy({ commit, getters }, payload) {
      commit("clearError");
      commit("setLoading", true);

      try {
        payload.forEach((record) => {
          fetch('/api/business/compliance_policies/' + record.policyId, {
              method: 'PATCH',
              headers: {
                // 'Authorization': 'Bearer test',
                'Accept': 'application/json',
                'Content-Type': 'application/json'},
              body: JSON.stringify({
                compliance_policy: {
                  // id: record.policyId,
                  position: record.position,
                }
              })
            }).then(response => {
              console.log(response)
              if (!response.ok)
                throw new Error(`Could't update policy (${response.status})`);
              return response.json()
            }).then(response => {
              console.log(response)
              return response
            }).catch (error => {
              console.error(error)
              throw error;
            })
              .finally(() => commit("setLoading", false))
        })

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
  },
  getters: {
    policies(state) {
      return state.policies;
    },
  },
};
