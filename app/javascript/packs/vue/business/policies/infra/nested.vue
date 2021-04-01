<template lang="pug">
  draggable.dragArea(tag='div' :group="{ name: 'g1' }" @end="onEnd")
      .table.mb-0(v-for='el in policies' :key='el.title')
        .table__row
          .table__cell.table__cell_name.px-0.pb-0.pl-2(v-if="el.sections && el.sections.length !== 0 || el.children && el.children.length !== 0")
            .dropdown-toggle(:class="[el.sections && el.sections.length !== 0 || el.children && el.children.length !== 0 ? 'active' : '']")
              b-icon.mr-2(v-if="el.sections && el.sections.length !== 0 || el.children && el.children.length !== 0" icon="chevron-compact-down")
              b-icon.mr-2(v-else icon="chevron-compact-right")
              | {{ el.title }}
            nested-draggable(:policies='el.children ? el.children : el.sections')
          .table__cell.table__cell_name(v-else) {{ el.title }}
  <!--draggable.dragArea(tag='ul' :list='policies' :group="{ name: 'g1' }")-->
    <!--li(v-for='el in policies' :key='el.title')-->
      <!--p {{ el.title }}-->
      <!--nested-draggable(:tasks='el.sections ? el.sections : el.children')-->
</template>
<script>
  import draggable from "vuedraggable";
  export default {
    props: ['policies'],
    name: "nested-draggable",
    components: {
      draggable
    },
    methods: {
      onEnd(event) {
        this.$emit('movePolicy', event)
      },
    }
  };
</script>
<style scoped>
  .dragArea {
    /*min-height: 50px;*/
    outline: 1px dashed transparent;
    transition: all 200ms ease-in;
  }
  .dragArea:hover,
  .dragArea:active {
    /*height: 50px;*/
    outline-color: #ced4da;
  }
</style>
