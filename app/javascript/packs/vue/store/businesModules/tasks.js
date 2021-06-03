import * as jwt from '@/services/business/tasks'

const mapAuthProviders = {
  jwt: {
    getTasks: jwt.getTasks,
    getTasksByDate: jwt.getTasksByDate,
    getOverdueTasks: jwt.getOverdueTasks,
    createTask: jwt.createTask,
    updateTask: jwt.updateTask,
    deleteTask: jwt.deleteTask,
    getTaskById: jwt.getTaskById,
  },
}

import Task from "../../models/Task";

export default {
  state: {
    tasks: [],
    currentTask: null,
  },
  mutations: {
    SET_TASKS(state, payload) {
      state.tasks = payload
    },
    SET_CURRENT_TASK (state, payload) {
      state.currentTask = payload
    },
    ADD_TASK(state, payload) {
      state.tasks.push(payload)
    },
    UPDATE_TASK(state, payload) {
      const index = state.tasks.findIndex(record => record.id === payload.id);
      state.tasks.splice(index, 1, payload)
    },
    UPDATE_CURRENT_TASK(state, payload) {
      state.currentTask = payload
    },
    DELETE_TASK(state, payload) {
      const index = state.tasks.findIndex(record => record.id === payload.id);
      state.tasks.splice(index, 1)
    },
  },
  actions: {
    async getTasks({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getTasks = mapAuthProviders[rootState.shared.settings.authProvider].getTasks
        const data = getTasks()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              const tasks = []
              for (const taskItem of data) {
                tasks.push(new Task(
                  taskItem.body,
                  taskItem.created_at,
                  taskItem.description,
                  taskItem.done_at,
                  taskItem.done_occurencies,
                  taskItem.end_by,
                  taskItem.end_date,
                  taskItem.id,
                  taskItem.linkable_id,
                  taskItem.linkable_type,
                  taskItem.note,
                  taskItem.on_type,
                  taskItem.remind_at,
                  taskItem.remindable_id,
                  taskItem.remindable_type,
                  taskItem.repeat_every,
                  taskItem.repeat_on,
                  taskItem.repeats,
                  taskItem.skip_occurencies,
                  taskItem.updated_at,
                ))
              }
              commit('SET_TASKS', tasks)
              return success
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
    async getTasksByDate({state, commit, rootState}, payload) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getTasksByDate = mapAuthProviders[rootState.shared.settings.authProvider].getTasksByDate
        const data = await getTasksByDate(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data.tasks
              const tasks = []
              for (const taskItem of data) {
                tasks.push(new Task(
                  taskItem.body,
                  taskItem.created_at,
                  taskItem.description,
                  taskItem.done_at,
                  taskItem.done_occurencies,
                  taskItem.end_by,
                  taskItem.end_date,
                  taskItem.id,
                  taskItem.linkable_id,
                  taskItem.linkable_type,
                  taskItem.note,
                  taskItem.on_type,
                  taskItem.remind_at,
                  taskItem.remindable_id,
                  taskItem.remindable_type,
                  taskItem.repeat_every,
                  taskItem.repeat_on,
                  taskItem.repeats,
                  taskItem.skip_occurencies,
                  taskItem.updated_at,
                ))
              }
              commit('SET_TASKS', tasks)
              return success.data
            }
            if (!success) {
              console.error('Not success', success)
              commit("setError", success.message, { root: true });
            }
          })
          .catch(error => error)
        return data;
      } catch (error) {
        console.error('catch error', error);
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
        throw error
      }
    },
    async getOverdueTasks({state, commit, rootState}) {
      commit("clearError", null, { root: true });
      commit("setLoading", true, { root: true });
      try {
        const getOverdueTasks = mapAuthProviders[rootState.shared.settings.authProvider].getOverdueTasks
        const data = getOverdueTasks()
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data.tasks
              const tasks = []
              for (const taskItem of data) {
                tasks.push(new Task(
                  taskItem.body,
                  taskItem.created_at,
                  taskItem.description,
                  taskItem.done_at,
                  taskItem.done_occurencies,
                  taskItem.end_by,
                  taskItem.end_date,
                  taskItem.id,
                  taskItem.linkable_id,
                  taskItem.linkable_type,
                  taskItem.note,
                  taskItem.on_type,
                  taskItem.remind_at,
                  taskItem.remindable_id,
                  taskItem.remindable_type,
                  taskItem.repeat_every,
                  taskItem.repeat_on,
                  taskItem.repeats,
                  taskItem.skip_occurencies,
                  taskItem.updated_at,
                ))
              }
              commit('SET_TASKS', tasks)
              return success.data
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
    async createTask({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const createTask = mapAuthProviders[rootState.shared.settings.authProvider].createTask
        createTask(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('ADD_EXAM', new Task(
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
              ))
              return success
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
    },
    async updateTask({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const updateTask = mapAuthProviders[rootState.shared.settings.authProvider].updateTask
        updateTask(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('UPDATE_EXAM', new Task(
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
              ))
              commit('UPDATE_CURRENT_EXAM', new Task(
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
              ))
              return success
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
    },
    async deleteTask({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const deleteTask = mapAuthProviders[rootState.shared.settings.authProvider].deleteTask
        deleteTask(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('DELETE_EXAM', new Task(
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
              ))
              return success
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
    },
    async getTaskById({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const getTaskById = mapAuthProviders[rootState.shared.settings.authProvider].getTaskById
        getTaskById(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              commit('SET_CURRENT_EXAM', new Task(
                data.complete,
                data.created_at,
                data.ends_on,
                data.exam_requests,
                data.id,
                data.name,
                data.share_uuid,
                data.starts_on,
                data.updated_at,
              ))
              return success
            }
            if (!success) {
              console.error('Not success', success)
            }
          })
          .catch(error => error)
      } catch (error) {
        commit("setError", error.message, {
          root: true
        });
        commit("setLoading", false, {
          root: true
        });
        throw error;
      }
    },
  },
  getters: {
    tasks: state => state.tasks,
    currentTask: state => state.currentTask
  },
};
