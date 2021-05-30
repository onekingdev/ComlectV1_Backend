import { DateTime } from 'luxon'

const isProject = task => task.hasOwnProperty('starts_on') && task.hasOwnProperty('ends_on')
const isTask = task => task.hasOwnProperty('remindable_type') && task.hasOwnProperty('skip_occurencies')
const isOverdue = task => (task.end_date || task.ends_on) && DateTime.fromISO(task.end_date || task.ends_on) <= DateTime.local()
const isComplete = task => {
  const { oid } = splitReminderOccurenceId(task.id)
  if (oid !== null) {
    return task.done_occurencies.hasOwnProperty(`${oid}`)
  } else {
    return (task.completed_at || task.done_at)
  }
}
const toEvent = (task) => ({
  ...task,
  ...splitReminderOccurenceId(task.id),
  start: task.starts_on || task.remind_at,
  end: ( task.end_date || task.ends_on )+" 20:00:00",
  title: task.title || task.body,
  icons: iconArray(task)
})
const cssClass = task => isComplete(task) ? 'task-is-complete'
                       : isOverdue(task) ? 'task-is-overdue'
                       : isProject(task) ? 'task-is-project'
                       : isTask(task) ? 'task-is-task' : ''
const iconArray = (task) => [
  isComplete(task) ? 'checkbox-outline' : isOverdue(task) ? 'warning-outline' : null,
  isProject(task) ? 'list-outline' : isTask(task) ? 'checkbox-outline' : null
].filter(i => i).filter((v, i, a) => a.indexOf(v) === i)
const splitReminderOccurenceId = val => {
  const matches = [...`${val}`.matchAll(/(\d+)_(\d+)/ig)]
  return (matches && matches[0])
    ? { taskId: +matches[0][1], oid: +matches[0][2] }
    : { taskId: val, oid: null }
}
const badgeClass = project => project.status == "pending" ? 'badge-secondary'
                            : project.status == "inprogress" ? "badge-light"
                            : project.status == "complete" ? "badge-success"
                            : project.status == "draft" ? 'badge-secondary'
                            : isOverdue(project) ? "badge-warning" : ''

export { isProject, isTask, isOverdue, isComplete, toEvent, cssClass, splitReminderOccurenceId, iconArray, badgeClass }
