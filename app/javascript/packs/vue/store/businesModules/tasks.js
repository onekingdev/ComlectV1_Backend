import * as jwt from '@/services/business/tasks'

const mapAuthProviders = {
  jwt: {
    getTasks: jwt.getTasks,
    getTasksByDate: jwt.getTasksByDate,
    getOverdueTasks: jwt.getOverdueTasks,
    createTask: jwt.createTask,
    updateTask: jwt.updateTask,
    updateTaskStatus: jwt.updateTaskStatus,
    deleteTask: jwt.deleteTask,
    getTaskById: jwt.getTaskById,
    getTaskMessagesById: jwt.getTaskMessagesById,
    postTaskMessageById: jwt.postTaskMessageById,
  },
}

import { Task, TaskOverdue, TaskMessage } from "../../models/Task";

export default {
  state: {
    tasks: [],
    currentTask: null,
    currentTaskMessages: []
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
    CONCAT_OVERDUE_TASKS(state, payload) {
      state.tasks = state.tasks.concat(payload)
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
    GET_CURRENT_TASK_MESSAGES(state, payload) {
      state.currentTaskMessages = payload
    },
    UPDATE_CURRENT_TASK_MESSAGES(state, payload) {
      state.currentTaskMessages.push(payload)
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
              // const tasks = []
              // for (const taskItem of data) {
              //   tasks.push(new Task(
              //     taskItem.body,
              //     taskItem.created_at,
              //     taskItem.description,
              //     taskItem.done_at,
              //     taskItem.done_occurencies,
              //     taskItem.end_by,
              //     taskItem.end_date,
              //     taskItem.id,
              //     taskItem.linkable_id,
              //     taskItem.linkable_type,
              //     taskItem.note,
              //     taskItem.on_type,
              //     taskItem.remind_at,
              //     taskItem.remindable_id,
              //     taskItem.remindable_type,
              //     taskItem.repeat_every,
              //     taskItem.repeat_on,
              //     taskItem.repeats,
              //     taskItem.skip_occurencies,
              //     taskItem.updated_at,
              //   ))
              // }
              commit('SET_TASKS', data)
              return data
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
    async createTask({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const createTask = mapAuthProviders[rootState.shared.settings.authProvider].createTask
        const result = await createTask(payload)
          .then((success) => {
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });
            if (success) {
              const data = success.data
              commit('ADD_TASK', new Task(
                data.body,
                data.created_at,
                data.description,
                data.done_at,
                data.done_occurencies,
                data.end_by,
                data.end_date,
                data.id,
                data.linkable_id,
                data.linkable_type,
                data.note,
                data.on_type,
                data.remind_at,
                data.remindable_id,
                data.remindable_type,
                data.repeat_every,
                data.repeat_on,
                data.repeats,
                data.skip_occurencies,
                data.updated_at,
              ))
              return data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => error)
        if (result) return result
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
            console.log('success123', success)
            commit("clearError", null, {
              root: true
            });
            commit("setLoading", false, {
              root: true
            });

            if(success.statusText !== "OK") throw new Error(success.statusText)

            if (success) {
              const data = success.data
              commit('UPDATE_TASK', new Task(
                data.body,
                data.created_at,
                data.description,
                data.done_at,
                data.done_occurencies,
                data.end_by,
                data.end_date,
                data.id,
                data.linkable_id,
                data.linkable_type,
                data.note,
                data.on_type,
                data.remind_at,
                data.remindable_id,
                data.remindable_type,
                data.repeat_every,
                data.repeat_on,
                data.repeats,
                data.skip_occurencies,
                data.updated_at,
              ))
              commit('UPDATE_CURRENT_TASK', new Task(
                data.body,
                data.created_at,
                data.description,
                data.done_at,
                data.done_occurencies,
                data.end_by,
                data.end_date,
                data.id,
                data.linkable_id,
                data.linkable_type,
                data.note,
                data.on_type,
                data.remind_at,
                data.remindable_id,
                data.remindable_type,
                data.repeat_every,
                data.repeat_on,
                data.repeats,
                data.skip_occurencies,
                data.updated_at,
              ))
              return data
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
    async updateTaskStatus({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const updateTaskStatus = mapAuthProviders[rootState.shared.settings.authProvider].updateTaskStatus
        const data = updateTaskStatus(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });

            if(success.statusText !== "OK") throw new Error(`${success.status} ${success.statusText}`)

            if (success) {
              const data = success.data
              commit('UPDATE_TASK', new Task(
                data.body,
                data.created_at,
                data.description,
                data.done_at,
                data.done_occurencies,
                data.end_by,
                data.end_date,
                data.id,
                data.linkable_id,
                data.linkable_type,
                data.note,
                data.on_type,
                data.remind_at,
                data.remindable_id,
                data.remindable_type,
                data.repeat_every,
                data.repeat_on,
                data.repeats,
                data.skip_occurencies,
                data.updated_at,
              ))
              commit('UPDATE_CURRENT_TASK', new Task(
                data.body,
                data.created_at,
                data.description,
                data.done_at,
                data.done_occurencies,
                data.end_by,
                data.end_date,
                data.id,
                data.linkable_id,
                data.linkable_type,
                data.note,
                data.on_type,
                data.remind_at,
                data.remindable_id,
                data.remindable_type,
                data.repeat_every,
                data.repeat_on,
                data.repeats,
                data.skip_occurencies,
                data.updated_at,
              ))
              return data
            }
            if (!success) {
              commit("setError", success.message, { root: true });
              console.error('Not success', success)
            }
          })
          .catch(error => {
            console.error('catch error', error)
            throw error
          })

        if (data) return data

      } catch (error) {
        commit("setError", error.message, { root: true });
        commit("setLoading", false, { root: true });
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
              commit('DELETE_TASK', data.id ? data.id : payload.id)
              return data
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
              commit('UPDATE_TASK', new Task(
                data.body,
                data.created_at,
                data.description,
                data.done_at,
                data.done_occurencies,
                data.end_by,
                data.end_date,
                data.id,
                data.linkable_id,
                data.linkable_type,
                data.note,
                data.on_type,
                data.remind_at,
                data.remindable_id,
                data.remindable_type,
                data.repeat_every,
                data.repeat_on,
                data.repeats,
                data.skip_occurencies,
                data.updated_at,
              ))
              commit('UPDATE_CURRENT_TASK', new Task(
                data.body,
                data.created_at,
                data.description,
                data.done_at,
                data.done_occurencies,
                data.end_by,
                data.end_date,
                data.id,
                data.linkable_id,
                data.linkable_type,
                data.note,
                data.on_type,
                data.remind_at,
                data.remindable_id,
                data.remindable_type,
                data.repeat_every,
                data.repeat_on,
                data.repeats,
                data.skip_occurencies,
                data.updated_at,
              ))
              return data
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
    async getTaskMessagesById({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const getTaskMessagesById = mapAuthProviders[rootState.shared.settings.authProvider].getTaskMessagesById
        getTaskMessagesById(payload)
          .then(success => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });

            if(success.statusText !== "OK") throw new Error(`${success.status} ${success.statusText}`)

            if (success) {
              const data = success.data
              // const messages = []
              // for (const taskMessage of data) {
              //   console.log('taskMessage', taskMessage)
              //   messages.push(new TaskMessage(
              //     taskMessage.created_at,
              //     taskMessage.file_data,
              //     taskMessage.id,
              //     taskMessage.message,
              //     taskMessage.recipient,
              //     taskMessage.sender,
              //   ))
              // }
              commit('GET_CURRENT_TASK_MESSAGES', data)
              return data
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
    async postTaskMessageById({state, commit, rootState}, payload) {
      commit("clearError", null, {
        root: true
      });
      commit("setLoading", true, {
        root: true
      });
      try {
        const postTaskMessageById = mapAuthProviders[rootState.shared.settings.authProvider].postTaskMessageById
        postTaskMessageById(payload)
          .then((success) => {
            commit("clearError", null, { root: true });
            commit("setLoading", false, { root: true });
            if (success) {
              const data = success.data
              commit('UPDATE_CURRENT_TASK_MESSAGES', data)
              // commit('UPDATE_CURRENT_TASK_MESSAGES', new TaskMessage(
              //   data.created_at,
              //   data.file_data,
              //   data.id,
              //   data.message,
              //   data.recipient,
              //   data.sender,
              // ))
              return data
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
    currentTask: state => state.currentTask,
    currentTaskMessages: state => state.currentTaskMessages
  },
};
