<template lang="pug">
  <!--table(v-if="!loading && policiesComputed && policiesComputed.length !== 0")-->
    <!--thead-->
      <!--tr-->
        <!--td Name-->
        <!--td Status-->
          <!--b-icon.ml-2(icon='chevron-expand')-->
        <!--td Last Modified-->
          <!--b-icon.ml-2(icon='chevron-expand')-->
        <!--td Date Created-->
          <!--b-icon.ml-2(icon='chevron-expand')-->
        <!--td Risk Level-->
          <!--b-icon.ml-2(icon='chevron-expand')-->
        <!--td-->
    <!--nested(v-model='policiesComputed', :policiesList="policies")-->
  draggable.dragArea(tag='tbody' :group="{ name: 'g1' }")
    tr(v-for='el in policies' :key='el.title')
      td {{ el.title }}
      td {{ el.status }}
      td {{ el.updated_at }}
      td {{ el.created_at }}
      td N/A
      td
        .actions ...
      nested-draggable(:policies='el.children')
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

    }
  };
</script>
<style scoped>
  .dragArea {
    min-height: 50px;
  }
</style>
