<template lang="pug">
  div
    h3 Simple table without drag'n'drop
    .table
      .table__row(v-for="(policy, i) in policies" :key="i")
        .table__cell.table__cell_name {{ policy.title }}
          ul.dropdow-items.d-block(v-if="policy.children")
            .li(v-for="(policySection, i) in policy.children" :key="i") {{ policySection.title }}
              ul.dropdow-items.d-block(v-if="policySection.children")
                .li(v-for="(policySectionChild, i) in policySection.children" :key="i") {{ policySectionChild.title }}
    h3 DraggableTree
    <!--DraggableTree(:data="policyComputed" draggable crossTree @change="treeChange" :ondragend="testFunc")-->
      <!--div(slot-scope="{data, store, vm}")-->
        <!--//- data is node-->
        <!--//- store is the tree-->
        <!--//- vm is node Vue instance, you can get node level by vm.level-->
        <!--template(v-if="!data.isDragPlaceHolder")-->
          <!--b(v-if="data.children && data.children.length" @click="store.toggleOpen(data)")-->
            <!--b-icon.mr-2(v-if="data.open" icon="chevron-compact-down")-->
            <!--b-icon.mr-2(v-else icon="chevron-compact-right")-->
          <!--span.link {{data.title}}-->
    .row
      .col-12
        h3 Nested draggable
        nested-draggable(:policies='policies')
          rawdisplayer(:value='policies' title='List')
</template>
<script>
  // import { DraggableTree } from "vue-draggable-nested-tree";
  // import VueDragula from "vue-dragula";
  import nestedDraggable from "./infra/nested";

  export default {
    props: ["policies"],
    components: {
      // DraggableTree,
      // VueDragula
      nestedDraggable,
    },
    data() {
      return {
        display: "Nested",
        order: 15,
        list: [
          {
            name: "task 1",
            tasks: [
              {
                name: "task 2",
                tasks: []
              }
            ]
          },
          {
            name: "task 3",
            tasks: [
              {
                name: "task 4",
                tasks: []
              }
            ]
          },
          {
            name: "task 5",
            tasks: []
          }
        ],

        treeJson: null,
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
      // policyComputed() {
      //   const newPolicyComputed = this.policy;
      //   let tmp;
      //   tmp = newPolicyComputed.name;
      //   newPolicyComputed.title = tmp;
      //   tmp = newPolicyComputed.sections;
      //   newPolicyComputed.children = tmp;
      //
      //   console.log('newPolicyComputed', newPolicyComputed);
      //
      //   return [newPolicyComputed]
      // }
      // policiesComputed() {
      //   const policies = this.policies
      //   let tmp
      //   const newPolicies = policies.map(el => {
      //     tmp = el['name'];
      //     el['title'] = tmp;
      //     tmp = el['sections']
      //     el['children'] = tmp;
      //     return el
      //   });
      //   return newPolicies;
      // }
    },
    methods: {
      // treeChange(node, nodeVm, store) {
      //   console.log(node)
      //   console.log(nodeVm)
      //   console.log(store)
      //   this.treeJson = nodeVm.pure(nodeVm.rootData, true).children
      //   console.log('this.treeJson', this.treeJson)
      // },
      // testFunc(node, nodeVm, store) {
      //   console.log(node)
      //   console.log(nodeVm)
      //   console.log(store)
      //   console.log("dragged id", node.id, node.title)
      //   console.log("new parent id", node.parent.id, node.parent.title)
      // },
    },
  };
</script>
