import { DateTime } from 'luxon'

const isProject = task => task.hasOwnProperty('only_regulators') && task.hasOwnProperty('key_deliverables')
const isTask = task => task.hasOwnProperty('remindable_type') && task.hasOwnProperty('skip_occurencies')
const isOverdue = task => DateTime.fromISO(task.starts_on || task.remind_at) <= DateTime.local()
const isComplete = task => task.completed_at || task.done_at
const toEvent = (task) => ({
  ...task,
  start: task.starts_on || task.remind_at,
  end: ( task.end_date || task.ends_on )+" 20:00:00",
  title: task.title || task.body
})
const cssClass = task => isComplete(task) ? 'task-is-complete'
                       : isOverdue(task) ? 'task-is-overdue'
                       : isProject(task) ? 'task-is-project'
                       : isTask(task) ? 'task-is-task' : ''

export { isProject, isTask, isOverdue, isComplete, toEvent, cssClass }