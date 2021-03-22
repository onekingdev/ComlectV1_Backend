<template lang="pug">
  div
    .table
      .table__row(v-for="(policy, i) in policies" :key="i")
        .table__cell.table__cell_name {{ policy.title }}
          ul.dropdow-items.d-block(v-if="policy.sections")
            .li(v-for="(policySection, i) in policy.sections" :key="i") {{ policySection.title }}
              ul.dropdow-items.d-block(v-if="policySection.children")
                .li(v-for="(policySectionChild, i) in policySection.children" :key="i") {{ policySectionChild.title }}
    DraggableTree(:data="data" draggable crossTree)
      div(slot-scope="{data, store, vm}")
        //- data is node
        //- store is the tree
        //- vm is node Vue instance, you can get node level by vm.level
        template(v-if="!data.isDragPlaceHolder")
          b(v-if="data.children && data.children.length" @click="store.toggleOpen(data)") {{data.open ? '-' : '+'}}&nbsp;
          span {{data.text}}
</template>
<script>
  import { DraggableTree } from "vue-draggable-nested-tree";

  export default {
    props: ["policies"],
    components: {
      DraggableTree,
    },
    data() {
      return {
        data: [
          { text: "node 1" },
          { text: "node 2" },
          { text: "node 3 undraggable", draggable: false },
          { text: "node 4" },
          { text: "node 4 undroppable", droppable: false },
          {
            text: "node 5",
            children: [
              { text: "node 1" },
              {
                text: "node 2",
                children: [{ text: "node 3" }, { text: "node 4" }],
              },
              {
                text: "node 2 undroppable",
                droppable: false,
                children: [{ text: "node 3" }, { text: "node 4" }],
              },
              {
                text: "node 2",
                children: [
                  { text: "node 3" },
                  { text: "node 4 undroppable", droppable: false },
                ],
              },
              { text: "node 3" },
              { text: "node 4" },
              { text: "node 3" },
              { text: "node 4" },
              { text: "node 3" },
              { text: "node 4" },
              { text: "node 3" },
              { text: "node 4" },
            ],
          },
        ],
      };
    },
    computed: {

    },
    methods: {

    },
  };
</script>

<!--<style>-->
<!--@import "./styles.css";-->
<!--</style>-->

<!--<style scoped>-->
<!--.table__cell {-->
<!--width: 20%;-->
<!--}-->
<!--.icon-searh {-->
<!--position: absolute;-->
<!--top: 50%;-->
<!--left: 0.5rem;-->
<!--transform: translateY(-50%);-->
<!--}-->
<!--.form-control {-->
<!--padding-left: 2rem;-->
<!--}-->
<!--</style>-->
