<template lang="pug">
    div
        //- DraggableTree(:data="data" draggable crossTree)
        //-     div(slot-scope="{data, store, vm}")
        //-         //- data is node
        //-         //- store is the tree
        //-         //- vm is node Vue instance, you can get node level by vm.level
        //-         template(v-if="!data.isDragPlaceHolder")
        //-             b(v-if="data.children && data.children.length" @click="store.toggleOpen(data)") {{data.open ? '-' : '+'}}&nbsp;
        //-             span {{data.text}}
        .table
            .table__row
                .table__cell.table__cell_title Name
                .table__cell.table__cell_title Status
                .table__cell.table__cell_title Last Modified
                .table__cell.table__cell_title Date Created
                .table__cell.table__cell_title Risk Level
                .table__cell
        DraggableTree.table(:data="data" draggable crossTree)
            .table(slot-scope="{data, store, vm}")
                //- data is node
                //- store is the tree
                //- vm is node Vue instance, you can get node level by vm.level
                template(v-if="!data.isDragPlaceHolder")
                    .table__row
                        .table__cell.table__cell_name
                            b(v-if="data.children && data.children.length" @click="store.toggleOpen(data)") {{data.open ? '-' : '+'}}&nbsp;
                            span {{data.text}}
                        .table__cell
                            .status.status__published Published
                        .table__cell 1/20/2021
                        .table__cell 1/20/2021
                        .table__cell N/A
                        .table__cell
                            .actions
                                button.btn
                                    b-icon(icon="three-dots")

</template>
<script>
import { DraggableTree } from "vue-draggable-nested-tree";

export default {
  props: ["policy"],
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
  methods: {
    log(event) {
      console.log(event);
    },
  },
};
</script>

<style>
@import "./styles.css";
</style>

<style scoped>
.table__cell {
  width: 20%;
}
.icon-searh {
  position: absolute;
  top: 50%;
  left: 0.5rem;
  transform: translateY(-50%);
}
.form-control {
  padding-left: 2rem;
}
</style>
