import { DateTime } from 'luxon'

const isProject = task => task.hasOwnProperty('only_regulators') && task.hasOwnProperty('key_deliverables')
const isTask = task => task.hasOwnProperty('remindable_type') && task.hasOwnProperty('skip_occurencies')
const isOverdue = task => DateTime.fromISO(task.starts_on || task.remind_at) <= DateTime.local()
const isComplete = task => task.completed_at || task.done_at
const toEvent = (task) => ({
  ...task,
  start: task.starts_on || task.remind_at,
  end: task.ends_on,
  title: task.title || task.body
})

export { isProject, isTask, isOverdue, isComplete, toEvent }