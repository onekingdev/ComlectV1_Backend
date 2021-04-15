// class Specialist {
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
    specialists: [],
  },
  mutations: {
    updateSpecialistsList(state, payload) {
      state.specialists = payload;
    },
  },
  actions: {
    async getSpecialists ({commit}) {
      commit("clearError");
      commit("setLoading", true);

      try {
        const endpointUrl = '/api/business/specialists'
        const data = await fetch(`${endpointUrl}`, { headers: {'Accept': 'application/json'}})
          .then(response => {
            return response.json()
          })
          .then(response => {
            commit('updateSpecialistsList', response)
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
    specialistsList(state) {
      return state.specialists;
    },
  },
};
