<template lang="pug">
  div
    .table
      .table__row
        .table__cell.table__cell_name {{ policy.title }}
          ul.dropdow-items.d-block(v-if="policy.sections")
            .li(v-for="(policySection, i) in policy.sections" :key="i") {{ policySection.title }}
              ul.dropdow-items.d-block(v-if="policySection.children")
                .li(v-for="(policySectionChild, i) in policySection.children" :key="i") {{ policySectionChild.title }}
    <!--DraggableTree(:data="policy" draggable crossTree)-->
      <!--div(slot-scope="{data, store, vm}")-->
        <!--//- data is node-->
        <!--//- store is the tree-->
        <!--//- vm is node Vue instance, you can get node level by vm.level-->
        <!--template(v-if="!data.isDragPlaceHolder")-->
          <!--b(v-if="data.children && data.children.length" @click="store.toggleOpen(data)")-->
            <!--b-icon.mr-2(v-if="data.open" icon="chevron-compact-down")-->
            <!--b-icon.mr-2(v-else icon="chevron-compact-right")-->
          <!--span.link {{data.title}}-->
</template>
<script>
  import { DraggableTree } from "vue-draggable-nested-tree";
  // import { VueDragula } from 'vue-dragula"

  export default {
    props: ["policy"],
    components: {
      DraggableTree,
      // VueDragula
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
