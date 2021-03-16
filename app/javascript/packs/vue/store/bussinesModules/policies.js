class Policy {
  constructor(title, description, ownerId = null, id = null) {
    this.title = title;
    this.description = description;
    this.ownerId = ownerId;
    this.id = id;
  }
}

export default {
  state: {
    policies: [],
  },
  mutations: {
    createPolicy(state, payload) {
      state.policies.push(payload);
    },
  },
  actions: {
    createPolicy({ commit, getters }, payload) {
      console.log(payload);
      commit("clearError");
      commit("setLoading", true);

      const image = payload.image;

      try {
        const newPolicy = new Policy(
          payload.name, // goes to title
          payload.description
          //   getters.user.id,
        );

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
