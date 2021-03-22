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

        commit("setLoading", false);
        commit("updatePolicy", {
          ...updatePolicy,
        });

      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    async createSection({ commit, getters }, payload) {
      console.log(payload)
      commit("clearError");
      commit("setLoading", true);

      try {
        const newSection = {
          id: payload.id,
          title: payload.title,
          description: payload.description,
          children: payload.children
        };

        setTimeout(() => {
          commit("setLoading", false);
          commit('updatePolicy', { ...newSection })
        }, 3000);
      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    // async getPolicyById ({commit, getters}, payload) {
    //     const endpointUrl = '/api/business/compliance_policies/'
    //
    //     const data = await fetch(`${endpointUrl}1`, { headers: {'Accept': 'application/json'}})
    //         .then(response => {
    //             console.log(response)
    //             response.json()
    //         })
    //         .then(result => console.log(result))
    //         .catch(error => console.log(error))
    //     return data;
    // },
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
  },
  getters: {
    policies(state) {
      return state.policies;
    },
  },
};
