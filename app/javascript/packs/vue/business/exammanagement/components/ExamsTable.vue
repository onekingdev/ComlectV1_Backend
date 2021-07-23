<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3.m-y-0 Regulatory Exams
      ExamModalCreate(:exams-id="exams.id")
        button.btn.btn-dark New Exam
    .card-body
      Loading
      table.table(v-if="!loading")
        thead(v-if="exams && exams.length")
          tr
            th(@click="sortSelect('name', 'string')" width="40%")
              .d-inline
                | Name
                b-icon.ml-2(icon='chevron-expand')
            th
              .d-inline
                | Status
                b-icon.ml-2(icon='chevron-expand')
            th(@click="sortSelect('created_at', 'date')").text-right
              .d-inline
                | Date created
                b-icon.ml-2(icon='chevron-expand')
            th(@click="sortSelect('updated_at', 'date')").text-right
              .d-inline
                | Last Modified
                b-icon.ml-2(icon='chevron-expand')
            th(width="30px")
        tbody
          ExamItem(v-for="item in sortedView" :key="item.id" :item="item")

      table(v-if="!loading && exams && !exams.length")
        tbody
          tr
            td(colspan="4").text-center
              h3 Exams management not exist

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import ExamModalCreate from '../modals/ExamModalCreate'
  import ExamItem from "./ExamItem"

  export default {
    props: {
      exams: {
        type: Array,
        required: false
      }
    },
    components: {
      Loading,
      ExamModalCreate,
      ExamItem,
    },
    data () {
      return {
        sortOptions: {
          field: 'status',
          type: 'number',
          reverse: false
        }
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
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      sortedView () {
        const sortOption = this.sortOptions
        return this.exams.sort((itemA, itemB)=> {
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
    }
  }
</script>

<style scoped>
  .link {
    max-width: 400px;
    word-break: break-all;
  }
  .d-inline {
    cursor: pointer;
  }
</style>
