class Policy {
  constructor(id = null, ownerId = null, title, description, sections = null) {
    this.id = id;
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
    createSections(state, payload) {
      state.sections.push(payload);
    },
    updatePolicy(state, payload) {
      state.policies[payload.id].sections.push(payload);
    }
  },
  actions: {
    createPolicy({ commit, getters }, payload) {
      console.log('payload', payload);
      commit("clearError");
      commit("setLoading", true);

      try {
        const newPolicy = new Policy(
            payload.id,
            payload.ownerId,
            payload.title,
            payload.description,
            payload.sections,
            //   getters.user.id,
        );
        console.log('newPolicy', newPolicy);

        setTimeout(() => {
          commit("setLoading", false);
          commit("createPolicy", {
            ...newPolicy,
            //   id: policy.key,
          });
        }, 3000);
      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    createSection({ commit, getters }, payload) {
      console.log('payload', payload);
      commit("clearError");
      commit("setLoading", true);

      try {
        const newSection = {
          id: payload.id,
          title: payload.title,
          description: payload.description
          //   getters.user.id,
        };

        setTimeout(() => {
          commit("setLoading", false);
          // commit("createPolicy", {
          //   ...newSection,
          //   //   id: policy.key,
          // });
          commit('updatePolicy', { ...newSection })
        }, 3000);
      } catch (error) {
        commit("setError", error.message);
        commit("setLoading", false);
        throw error;
      }
    },
    // async getPolicyById ({commit, getters}, payload) {
    //     const endpointUrl = '/api//business/compliance_policies/'
    //
    //     const data = await fetch(`${endpointUrl}1`, { headers: {'Accept': 'application/json'}})
    //         .then(response => {
    //             console.log(response)
    //             response.json()
    //         })
    //         .then(result => console.log(result))
    //         .catch(err => console.log(err))
    //     return data;
    // },
  },
  getters: {
    policies(state) {
      return state.policies;
    },
  },
};
