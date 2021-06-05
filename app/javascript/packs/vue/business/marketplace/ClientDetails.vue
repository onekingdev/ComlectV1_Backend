<template lang="pug">
  .card.m-t-1
    .card-header
      | {{ business.business_name }}
      br
      | {{ [business.country, business.city, business.state] | commas }}
    .card-body
      dl.row
        dt.col-sm-3 Industry
        dd.col-sm-9 {{ business.industries | names}}
        dt.col-sm-3 Jurisdictions
        dd.col-sm-9 {{ business.jurisdictions | names}}
        dt.col-sm-3 Employees
        dd.col-sm-9 {{ business.employees }}
        dt.col-sm-3 Description
        dd.col-sm-9 {{ business.description }}
</template>

<script>
export default {
  props: {
    business: {
      type: Object,
      required: true
    }
  }
}
</script>