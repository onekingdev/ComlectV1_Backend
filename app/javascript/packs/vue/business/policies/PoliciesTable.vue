<template lang="pug">
  div
    .row
      .col-lg-4.col-12
        .position-relative.p-b-20
          b-icon.icon-searh(icon='search')
          input.form-control.form-control_search(type="text" placeholder="Search" v-model="searchInput", @keyup="searching")
          button.btn-clear(v-if="isActive" @click="clearInput")
            b-icon.icon-clear(icon='x-circle')
      .col-4(v-if="policiesComputed.length !== 0 && searchInput")
        p Found {{ policiesComputed.length }} {{ policiesComputed.length === 1 ? 'result' : 'results' }}
    .row
      .col-12
        Loading
        .table.mb-0(v-if="!loading && policiesComputed && policiesComputed.length !== 0")
          .table__row
            .table__cell.table__cell_title Name
            .table__cell.table__cell_title.table__cell_clickable
              | Status
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable.text-right
              | Last Modified
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable.text-right
              | Date Created
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable.text-right
              | Risk Level
              b-icon.ml-2(icon='chevron-expand')
            .table__cell(style="width: 40px")
        nested-draggable(v-model='policiesComputed', :policiesList="policies")
        .table(v-if="!loading && policiesComputed.length === 0")
          .table__row
            .table__cell.text-center
              h3 Policies not exist
    <!--rawdisplayer(:value='policiesComputed' title='List')-->
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
      policiesComputed: {
        get() {
          return this.policies
        },
        set(value) {
          console.log('set value', value)
          // this.$store.commit("updatePoliciesList", value)
          // this.$store.dispatch("updatePolicySectionsById", {
          //   id: this.policy.id,
          //   sections: value
          // });
        }
      },
    }
  }
</script>
