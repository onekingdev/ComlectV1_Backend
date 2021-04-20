<template lang="pug">
  .card.m-t-1.purchase-summary
    .card-header
      | Purchase Summary
    .card-body.pb-0
      dl.row.mb-0
        dt.col-sm-6
          b Busines plan
        dd.col-sm-6.text-right $250
        dt.col-sm-6 10 Users (10 Free)
        dd.col-sm-6.text-right +$0
        dt.col-sm-6.text-success Billed Annualy
        dd.col-sm-6.text-right.text-success You saved $50
    hr
    .card-body.py-0
      dl.row.mb-0
        dt.col-sm-6
          b Tax
        dd.col-sm-6.text-right.m-b-0
          b $32.20
    hr
    .card-body.pt-0
      dl.row.mb-0
        dt.col-sm-6
          b Total
        dd.col-sm-6.text-right.m-b-0
          b $492.20
    .card-footer
      b-button.w-100(type='button' variant='dark') Complite purchase
</template>

<script>
export default {
  props: []
}
</script>

<style scoped>
  .purchase-summary {
    position: absolute;
    z-index: 1050;
    right: 5rem;
    top: 30%;
    width: 30rem;
    transform: translateY(-30%);
  }
</style>
