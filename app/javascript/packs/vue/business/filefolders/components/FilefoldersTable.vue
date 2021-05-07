<template lang="pug">
  table.table.reviews-table
    thead
      tr
        th(width="40%")
          | Name
        th(@click="sortSelect('progress', 'number')").text-right
          | Owner
          b-icon.ml-2(icon='chevron-expand')
        th(@click="sortSelect('findings', 'number')").text-right
          | Size
          b-icon.ml-2(icon='chevron-expand')
        th(@click="sortSelect('updated_at', 'date')").text-right
          | Last Modified
          b-icon.ml-2(icon='chevron-expand')
        th

    tbody
      FilefoldersItem(v-if="filefolders.folders" v-for="item in filefolders.folders" :key="item.id" :item="item" :itemType="'folder'")
      FilefoldersItem(v-if="filefolders.files" v-for="item in filefolders.files" :key="item.id" :item="item" :itemType="'file'")
</template>

<script>

import FilefoldersItem from "./FilefoldersItem"
export default {
  components: {
    FilefoldersItem
  },
  props: ['filefolders'],
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
    sortedReview () {
      const sortOption = this.sortOptions
      return this.filefolders.sort((itemA, itemB)=> {
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
