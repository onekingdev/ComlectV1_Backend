<template lang="pug">
  div
    .row.my-3
      .col-4
        .position-relative
          b-icon.icon-searh(icon='search')
          input.form-control(type="text" placeholder="Search" v-model="searchInput", @keyup="searching")
          button.btn-clear(v-if="isActive" @click="clearInput")
            b-icon.icon-clear(icon='x-circle')
      .col-4(v-if="policies.length !== 0 && searchInput")
        p Found {{ policies.length }} {{ policies.length === 1 ? 'result' : 'results' }}
    .row
      .col-12
        Loading
        .table(v-if="!loading && policies && policies.length !== 0")
          .table__row
            .table__cell.table__cell_title Name
            .table__cell.table__cell_title.table__cell_clickable
              | Status
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable
              | Last Modified
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable
              | Date Created
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable
              | Risk Level
              b-icon.ml-2(icon='chevron-expand')
            .table__cell
          nested-draggable(:policies='policies')
        .table(v-if="!loading && policies.length === 0")
          .table__row
            .table__cell.text-center
              h3 Policies not exist
    <!--rawdisplayer(:value='policies' title='List')-->
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import nestedDraggable from "./infra/nestedMain"
  import rawdisplayer from "./infra/raw-displayer"
  export default {
    props: ['policies'],
    components: {
      Loading,
      nestedDraggable,
      rawdisplayer,
    },
    data() {
      return {
        searchInput: '',
        isActive: false,
      }
    },
    methods: {
      searching () {
        if(this.searchInput.length) this.isActive = true
        this.$emit('searching', this.searchInput)
      },
      clearInput() {
        this.searchInput = ''
        this.isActive = false
        this.$emit('searching', this.searchInput)
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    }
  }
</script>
