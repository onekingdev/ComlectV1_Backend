<template lang="pug">
  table.table
    thead
      tr
        th(width="80%") Name
          b-icon.ml-2(icon='chevron-expand' font-scale="1")
        th(@click="sortSelect('created_at', 'date')").text-right Status
          b-icon.ml-2(icon='chevron-expand')
        th(width="35px")
    tbody
      AppItem(v-for="item in sortedData" :key="item.id" :item="item")
</template>

<script>

import AppItem from "./AppItem"
export default {
  components: {
    AppItem
  },
  props: {
    apps: {
      type: Array,
      required: true
    }
  },
  data () {
    return {
      sortOptions: {
        field: 'progress',
        type: 'number',
        reverse: false
      }
    }
  },
  computed: {
    sortedData () {
      const sortOption = this.sortOptions
      return this.apps.sort((itemA, itemB)=> {
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
