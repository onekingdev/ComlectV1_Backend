<template lang="pug">
  table.table.tasks-table
    thead
      tr
        th(width="40%")
          | Name
          b-icon.ml-2(icon='chevron-expand')
        th(v-if="!shortTable" width="25%")
          | Assignee
          b-icon.ml-2(icon='chevron-expand')
        th(v-if="!shortTable" @click="sortSelect('updated_at', 'date')").text-right
          | Start date
          b-icon.ml-2(icon='chevron-expand')
        th(@click="sortSelect('created_at', 'date')").text-right
          | Due date
          b-icon.ml-2(icon='chevron-expand')
        th(v-if="!shortTable" @click="sortSelect('files', 'number')").text-right
          | Files
          b-icon.ml-2(icon='chevron-expand')
        th(v-if="!shortTable" @click="sortSelect('comments', 'number')").text-right
          | Comments
          b-icon.ml-2(icon='chevron-expand')
        th.text-right(width="10%")
    tbody
      TaskItem(v-for="item in sortedTask" :key="item.id" :item="item" :shortTable="shortTable")
</template>

<script>

import TaskItem from "./TasksItem"
export default {
  components: {
    TaskItem
  },
  props: {
    tasks: {
      type: Array,
      required: true
    },
    shortTable: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      sortOptions: {
        field: 'files',
        type: 'number',
        reverse: false
      }
    }
  },
  computed: {
    sortedTask () {
      const sortOption = this.sortOptions
      return this.tasks.sort((itemA, itemB)=> {
        if (sortOption.type === 'number') {
          if (sortOption.reverse) {
            return  itemB[sortOption.field] - itemA[sortOption.field]
          }
          return itemA[sortOption.field] - itemB[sortOption.field]
        }
        if (sortOption.type === 'date') {
          const dateA = new Date(itemA[sortOption.field])
          const dateB = new Date(itemB[sortOption.field])
          if (sortOption.reverse) {
            return dateB - dateA
          }
          return dateA - dateB
        }
        if (sortOption.type === 'string') {
          const stringA = itemA[sortOption.field].toLowerCase()
          const stringB = itemB[sortOption.field].toLowerCase()
          if (sortOption.reverse) {
            if (stringA > stringB) {
              return -1
            }
            if (stringA < stringB) {
              return 1
            }
            return 0
          }
          if (stringA < stringB) {
            return -1
          }
          if (stringA > stringB) {
            return 1
          }
          return 0
        }
      })
    }
  },
  methods: {
    sortSelect (field, type) {
      const sortOption = this.sortOptions
      if (field === sortOption.field) {
        this.sortOptions.reverse = !sortOption.reverse
        return
      }
      this.sortOptions = {
        field: field,
        type: type,
        reverse: false
      }
    }
  }
}
</script>
