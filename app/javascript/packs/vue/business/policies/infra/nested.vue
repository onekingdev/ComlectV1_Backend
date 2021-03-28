<template lang="pug">
  draggable.dragArea(tag='ul' :list='policies' :group="{ name: 'g1' }")
    li(v-for='el in policies' :key='el.title')
      p.link
        b-icon.mr-2(v-if="el.children.length !== 0" icon="chevron-compact-down")
        b-icon.mr-2(v-else icon="chevron-compact-right")
        | {{ el.title }}
      nested-draggable(:policies='el.children')
</template>
<script>
  import draggable from "vuedraggable";
  export default {
    props: {
      policies: {
        required: true,
        type: Array
      }
    },
    components: {
      draggable
    },
    name: "nested-draggable"
  };
</script>
<style scoped>
  .dragArea {
    min-height: 50px;
    outline: 1px dashed #ced4da;
    list-style: none;
  }
</style>
