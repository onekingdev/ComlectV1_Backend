<template lang="pug">
  .card.m-t-1.purchase-summary
    .card-header
      | _name }}
      br
      | {.countr.cit.state] | commas }}
    .card-body
      dl.row
        dt.col-sm-3 Industry
        dd.col-sm-9 .industries | names}}
        dt.col-sm-3 Jurisdictions
        dd.col-sm-9 .jurisdictions | names}}
        dt.col-sm-3 Employees
        dd.col-sm-9 .employees }}
        dt.col-sm-3 Description
        dd.col-sm-9 .description }}
</template>

<script>
export default {
  props: []
}
</script>

<style scoped>
  .purchase-summary {
    position: absolute;
    right: 20rem;
    top: 0;
    width: 20rem;
    transform: translateY(-50%);
  }
</style>
