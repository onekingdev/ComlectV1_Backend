import * as jwt from '@/services/specialist/projects'

const mapAuthProviders = {
  jwt: {
    getProjects: jwt.getProjects,
    createProject: jwt.createProject,
  },
}

import LocalProject from "../../models/LocalProject";

export default {
  state: {
    projects: [],
    currentProject: null,
  },
  mutations: {
    SET_PROJECTS(state, payload) {
      state.projects = payload
    },
    SET_CURRENT_PROJECT (state, payload) {
      state.currentProject = payload
    },
    ADD_PROJECT(state, payload) {
      state.projects.push(payload)
    },
  },
  actions: {
    async getProjects({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getProjects = mapAuthProviders[rootState.shared.settings.authProvider].getProjects
        const data = getProjects()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              const projects = []
              for (const item of data) {
                projects.push(new LocalProject(
                  item.business,
                  item.business_id,
                  item.cost,
                  item.created_at,
                  item.description,
                  item.ends_on,
                  item.hide_on_calendar,
                  item.id,
                  item.projects,
                  item.reminders,
                  item.starts_on,
                  item.status,
                  item.title,
                  item.updated_at,
                  item.visible_project,
                ))
              }
              commit('SET_PROJECTS', projects)
              return data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)
        return data
      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
    },
    async createProject({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const createProject = mapAuthProviders[rootState.shared.settings.authProvider].createProject
        const data = createProject(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('ADD_PROJECT', new LocalProject(
                data.business,
                data.business_id,
                data.cost,
                data.created_at,
                data.description,
                data.ends_on,
                data.hide_on_calendar,
                data.id,
                data.projects,
                data.reminders,
                data.starts_on,
                data.status,
                data.title,
                data.updated_at,
                data.visible_project,
              ))
              return data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
        return data
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
      // } finally { commit("setLoading", false, { root: true }) }
    },
  },
  getters: {
    projects: state => state.projects,
    currentProject: state => state.currentProject
  },
};
